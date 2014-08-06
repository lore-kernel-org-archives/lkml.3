Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaHFNU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:20:27 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60879 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaHFNUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:20:24 -0400
Date: Wed, 6 Aug 2014 14:20:21 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Dave Young <dyoung@redhat.com>, catalin.marinas@arm.com,
        will.deacon@arm.com, matt.fleming@intel.com, ard.biesheuvel@linaro.org,
        msalter@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Message-ID: <20140806132021.GB15082@console-pimps.org>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
 <20140806130623.GI4179@bivouac.eciton.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806130623.GI4179@bivouac.eciton.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug, at 02:06:23PM, Leif Lindholm wrote:
> On Wed, Aug 06, 2014 at 04:38:25PM +0800, Dave Young wrote:
> > 
> > Adding a noefi boot param like in X86 to disable efi runtime services support.
> > 
> > This will be useful for debugging uefi problems. Also it will be useful
> > for later kexec/kdump work. Kexec on uefi support in X86 depends on a fixed vm
> > area specific for uefi runtime 1:1 mapping, kernel will switch to a different
> > page table for any uefi runtime callback in virtual mode. In arm64 similar
> > work probably is necessary. But kexec boot will just works with 'noefi' with
> > the limitaion of lacking runtime services. The runtime services is not critical
> > for kdump kernel for now. So as for kexec/kdump just leave the 1:1 mapping a
> > future work.
> 
> Since this is really turning an x86-specific feature into a generic
> one, could it be moved to core code?
> Maybe an efi.mask, reusing the efi_enabled defines, with an
> efi_disabled macro?
 
Why the new efi_disabled() and efi.mask? This is all achievable with
efi_enabled() and efi.flags, in fact, this kind of thing is exactly why
they were invented.

> Also, since this patch (and its x86 predecessor) is not really
> "noefi", could this be integrated with the "efi=" patch
> (http://permalink.gmane.org/gmane.linux.kernel.efi/4405),
> as an efi=noruntime option?
> 
> On x86, due to CSM, "noefi" was a useful fallback for completely
> broken (U)EFI implementations - but on an arm* UEFI system, there will
> be no fallback. Could it be wrapped in a kernel hacking config option?
 
I don't mind making "noefi" a synonym for "efi=noruntime" on x86, as
long as we keep "noefi" around with the same semantics it's always had.

And certainly if you're coming at this anew (like on arm(64)), I agree
"efi=noruntime" just makes a ton more sense than "noefi".

-- 
Matt Fleming, Intel Open Source Technology Center
