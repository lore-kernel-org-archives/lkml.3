Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968106Ab3DSKfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:35:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37876 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967984Ab3DSKf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:35:28 -0400
Date: Fri, 19 Apr 2013 12:35:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel
Message-ID: <20130419103519.GB21981@pd.tnic>
References: <20130412181956.GA13099@pd.tnic>
 <516A7760.7030907@kernel.org>
 <20130414110320.GB20547@pd.tnic>
 <20130416161852.GH5332@pd.tnic>
 <20130417232507.GC31059@amt.cnet>
 <20130418094629.GC21719@pd.tnic>
 <20130418133631.GA30965@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130418133631.GA30965@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 10:36:31AM -0300, Marcelo Tosatti wrote:
> > IOW, something which says "Enable KVM guest support" should enable all
> > the stuff needed for that.
> 
> I get your point, but thats up to the person selecting the options.

Ok.

> > Or do you want to keep the current CONFIG_KVM_GUEST separate for special
> > stuff?
> 
> Yes.

Ok.

> > Basically, I'm looking from the perspective of a kernel dev who would
> > like to make an optimal use of kvm for testing kernels.
> > 
> > Does that make more sense?
> 
> Understood (just don't mix it with the current CONFIG_KVM_GUEST option).

Ok, got it - we want those additional options in another Kconfig option,
probably depending on KVM_GUEST.

> Even though can't see why those options can live in defconfig files as
> suggested.

Well, for one, some of the options are already in the defconfig files.
However, you want to have a single shortcut option which selects those
when building randconfigs and trying to boot them in kvm. I.e., you want
some basic functionality to be always present, even with randconfigs.
And you won't have that functionality enabled if you put them in a
defconfig, AFAICT.

Now, I do that already in my tests by having those and other options in
an all.config file in the kernel repo which gets parsed by Kconfig.

The reason for adding this to the kernel though was to save other people
the time of looking for all those options everytime but have one single
shortcut. Which can also be updated by kvm people whenever they feel
like new guest kernel functionality should be enabled.

If people still feel like this is not a good idea, I can drop it. But it
makes a bunch of sense to me, currently at least :).

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
