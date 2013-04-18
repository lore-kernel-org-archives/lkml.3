Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030292Ab3DRKSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:18:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52709 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967288Ab3DRKS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:18:27 -0400
Date: Thu, 18 Apr 2013 12:18:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel
Message-ID: <20130418101820.GD21719@pd.tnic>
References: <20130412181956.GA13099@pd.tnic>
 <516A7760.7030907@kernel.org>
 <20130414110320.GB20547@pd.tnic>
 <20130416161852.GH5332@pd.tnic>
 <20130417232507.GC31059@amt.cnet>
 <20130418094629.GC21719@pd.tnic>
 <CAMuHMdVmeMfXKuO9FjHWjS80vUWqc-y0NA8YJruwtkz7QeQosA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdVmeMfXKuO9FjHWjS80vUWqc-y0NA8YJruwtkz7QeQosA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:55:33AM +0200, Geert Uytterhoeven wrote:
> On Thu, Apr 18, 2013 at 11:46 AM, Borislav Petkov <bp@alien8.de> wrote:
> > ok, maybe I wasn't clear enough. My proposal was to actually add all (or
> > maybe not *all* of them, but most) those selects above to the KVM_GUEST
> > config option. Because, you very probably want to select all that stuff
> > above anyway if you want to build a kvm guest kernel, no?
> >
> > IOW, something which says "Enable KVM guest support" should enable all
> > the stuff needed for that.
> 
> "needed" yes,
> "probably" no, as there's no way to disable them if they're selected
> unconditionally.
> 
> Perhaps you can make the "probably" selects depend on !EXPERT to fix this?

Nah, I don't want to really involve EXPERT here. You could point,
though, which are the ones one probably won't select even though it
would be good to have them on and I could stick them in the second,
kernel testing option.

IOW, The way it currently shapes up is this:

* CONFIG_KVM_GUEST - maybe not change it at all, depending on what kvm
people want in the end.

* CONFIG_KVM_KERNEL_TESTING - all the things you would - probably or
really - need selected so that you don't go and hunt Kconfig options
just so the damn guest kernel boots. And not only that but also
convenience stuff like debugging options and such so that you have the
chance of getting some more info when the guest dies.

That second option is to be enabled when building the guest kernel only,
of course.

Better?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
