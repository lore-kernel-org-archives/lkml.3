Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbaGNRW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:22:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbaGNRWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:22:41 -0400
Date: Mon, 14 Jul 2014 19:22:25 +0200
From: Borislav Petkov <bp@suse.de>
To: Stuart Hayes <stuart.w.hayes@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, matt.fleming@intel.com,
        bp@suse.de
Subject: Re: [PATCH] x86: Configure NX support earlier in setup_arch
Message-ID: <20140714172225.GE25120@pd.tnic>
References: <53B4B627.8060903@gmail.com>
 <53BC7210.1000305@gmail.com>
 <53BC72D8.4090705@zytor.com>
 <53BDE4BD.50605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53BDE4BD.50605@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 07:56:29PM -0500, Stuart Hayes wrote:
> Well... I got this issue because a co-worker tripped over it. He had
> NX disabled in BIOS for some reason, and found that linux wouldn't
> boot--it hung right after grub2. I guess it took a while to figure out
> that it was the fact that NX was disabled that caused linux not to
> come up--and that could happen to other people. I don't know of any
> real-world scenarios in which someone would actually prefer to run a
> recent linux kernel with NX disabled, though.
>
> It looks like some of the other boot paths into the kernel
> automatically clear the XD_DISABLE bit in the MISC_ENABLE MSR in the
> CPU (in verify_cpu), but that doesn't happen when grub2 jumps to
> startup_64 in arch/x86/boot/compressed/head_64.S. I guess instead
> of this patch, I could try to make a patch that turns NX back on
> (somewhere in startup_64), but since the kernel already supports NX
> being disabled, so I thought maybe just fixing that would be better. I
> didn't like seeing the kernel just die without giving any indication
> of what the problem is.

Well, hpa and I were talking about this briefly and this NX disabling
in the BIOS is probably for some broken legacy applications/OSes. Linux
enables NX unconditionally very early because disabling it is a very bad
idea anyway, security-wise.

So, if this is just a random trip over of a co-worker and doesn't have
any sensible use case, I'd rather leave it as is an don't fix it at all.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
