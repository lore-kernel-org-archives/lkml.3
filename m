Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaB0Poi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:44:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52095 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaB0Poh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:44:37 -0500
Date: Thu, 27 Feb 2014 16:44:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 07/11] kexec: Create a relocatable object called purgatory
Message-ID: <20140227154429.GF18191@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-8-git-send-email-vgoyal@redhat.com>
 <20140226160008.GF22639@pd.tnic>
 <20140226163256.GD23022@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140226163256.GD23022@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 11:32:56AM -0500, Vivek Goyal wrote:
> We have been using sha256 for last 7-8 years in kexec-tools and nobody
> asked for changing hash algorithm so far.
> 
> So yes, somebody wanting to use a different algorithm is a possibility
> but I don't think it is likely in near future.
> 
> This patchset is already very big. I would rather make it work with
> sha256 and down the line one can make it more generic if they feel
> the need. This is not a user space API/ABI and one should be able to
> change it without breaking any user space applications.
> 
> So I really don't feel the need of making it more complicated, pull in
> all the crypto API in purgaotry to support other kind of hash algorithms
> in purgatory.

Ok, makes sense. Right, if someone needs it, someone could add that
support fairly easily.

> No. One can modify purgatory object symbol entry64_regs dynamically from
> outside and purpose of this code is to load values into registers. At
> compile time value of entry64_regs is 0 so it kind of gives the impression
> that we are just trying to zero registers.
> 
> At kernel load time, we set values of some of those registers. Stack and
> kernel entry point is one of those. Look at
> arch/x86/kernel/kexec-bzimage.c
> 
>         regs64.rbx = 0; /* Bootstrap Processor */
>         regs64.rsi = bootparam_load_addr;
>         regs64.rip = kernel_load_addr + 0x200;
> 	regs64.rsp = (unsigned long)stack;
> 	ret = kexec_purgatory_get_set_symbol(image, "entry64_regs", &regs64,
>                                         sizeof(regs64), 0);

Ok, thanks for explaining.

> Kdump kernel runs from reserved region of memory. But we also found on
> x86, that it still needed first 640KB of memory to boot. So before jumping
> to second kernel, we copy first 640KB in reserved region and let second
> kernel use first 640KB. We call this concept as backup region as we are
> backing up an area of memory so that second kernel does not overwrite it.
> 
> For more details on backup region have a look at this paper.
> 
> http://lse.sourceforge.net/kdump/documentation/ols2oo5-kdump-paper.pdf

That's valuable info, can we put some of it in a comment in the code
somewhere?

> Yep. Right now these patches support 64bit kernel only and I put some
> code for 32bit so that there are no compilation failures. 
> 
> Though 32bit is becoming less relevant with every passing day, still
> supporting it on 32bit is a good idea. It can happen down the line tough.

Ok.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
