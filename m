Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaDYLK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:10:58 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46696 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbaDYLJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:09:43 -0400
Date: Fri, 25 Apr 2014 12:09:36 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@suse.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        ricardo.neri-calderon@linux.intel.com, tglx@linutronix.de,
        matt.fleming@intel.com, linux-tip-commits@vger.kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [tip:x86/efi] x86/efi: Save and restore FPU context around
 efi_calls (x86_64)
Message-ID: <20140425110936.GB26088@console-pimps.org>
References: <tip-de05764e0b2a3d9559e099a2e134f8cef4500fdd@git.kernel.org>
 <20140420002811.GA18663@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140420002811.GA18663@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr, at 02:28:11AM, Borislav Petkov wrote:
> 
> I guess you can use the kernel_fpu_begin/end() variants here (i.e.,
> without the "__") which disable and enable preemption and thus drop the
> preempt_* calls:
> 
> 	efi_sync_low_kernel_mappings();
> 	kernel_fpu_begin();
> 	 __s = efi_call((void *)efi.systab->runtime->f, __VA_ARGS__);
> 	 kernel_fpu_end();
> 	 __s;
> 
> I'm not sure about the
> 
> 	WARN_ON_ONCE(!irq_fpu_usable());
> 
> thing in kernel_fpu_begin() though, I guess it wouldn't hurt...

Hmm... note that we may call EFI runtime services from interrupt context
in efi_pstore_write(), so it seems like it would be possible to trigger
that WARN_ON_ONCE() there.

Seiji (Cc'd) might have some opinions on this.

Either way, if someone sends me a patch ontop of this one that swaps the
__kernel_fpu_begin() for kernel_fpu_begin() I can try them out in my
lab.

-- 
Matt Fleming, Intel Open Source Technology Center
