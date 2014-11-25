Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaKYRsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:48:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50233 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaKYRsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:48:04 -0500
Date: Tue, 25 Nov 2014 18:48:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, leif.lindholm@linaro.org,
        roy.franz@linaro.org, linux-arm-kernel@lists.infradead.org,
        mark.rutland@arm.com, msalter@redhat.com, dyoung@redhat.com,
        linux-efi@vger.kernel.org, matt.fleming@intel.com, will.deacon@arm.com,
        catalin.marinas@arm.com, grant.likely@linaro.org,
        geoff.levand@linaro.org, linux-kernel@vger.kernel.org,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH v3 03/13] arm64: improve CONFIG_STRICT_DEVMEM handling
Message-ID: <20141125174800.GA3938@pd.tnic>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
 <1416315432-8534-4-git-send-email-ard.biesheuvel@linaro.org>
 <20141125173925.GE3331@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141125173925.GE3331@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 05:39:25PM +0000, Matt Fleming wrote:
> On Tue, 18 Nov, at 01:57:02PM, Ard Biesheuvel wrote:
> > Improve the handling of /dev/mem mappings under CONFIG_STRICT_DEVMEM by:
> > - allowing read-only access to parts of System RAM that are not
> >   considered memory by the kernel, this is mainly intended for exposing
> >   UEFI Configuration tables to userland;
> > - avoid using non-cached mappings for those parts of System RAM, as it
> >   may result in mismatched attributes.
> 
> Is this really the best way to expose EFI config tables?
> 
> We already have parts in /sys/firmware/efi/ and in particular we expose
> the runtime mappings there for kexec on x86.

Yeah!

> Hooking this into the /dev/mem infrastructure just seems wrong to me.

And this virtmap.c thing is arm-only, AFAICT, but it looks like generic
code and like a wholly new way of doing the efi page table.

This thing needs to be properly split into generic pieces which go into
drivers/firmware/efi/ and arm-specific which would make that EFI_VIRTMAP
into an arch bit.

And so on and so on...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
