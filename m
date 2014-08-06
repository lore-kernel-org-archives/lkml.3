Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaHFN3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:29:53 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47130 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaHFN3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:29:50 -0400
Date: Wed, 6 Aug 2014 14:29:41 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>, catalin.marinas@arm.com,
        will.deacon@arm.com, matt.fleming@intel.com, ard.biesheuvel@linaro.org,
        msalter@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Message-ID: <20140806132941.GJ4179@bivouac.eciton.net>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
 <20140806130623.GI4179@bivouac.eciton.net>
 <20140806132021.GB15082@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806132021.GB15082@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 02:20:21PM +0100, Matt Fleming wrote:
> > Since this is really turning an x86-specific feature into a generic
> > one, could it be moved to core code?
> > Maybe an efi.mask, reusing the efi_enabled defines, with an
> > efi_disabled macro?
>  
> Why the new efi_disabled() and efi.mask? This is all achievable with
> efi_enabled() and efi.flags, in fact, this kind of thing is exactly why
> they were invented.

Because this flag is indicating which facilities we should not try to
enable, rather than which facilities we have enabled.

The EFI_RUNTIME_SERVICES flag is set after successful call to
set_virtual_address_map. The apparent intent of "noefi" is to prevent
that call from being made in the first place.

Anyway, it was just a suggestion - main point was it would make sense
to share the code.
 
> > Also, since this patch (and its x86 predecessor) is not really
> > "noefi", could this be integrated with the "efi=" patch
> > (http://permalink.gmane.org/gmane.linux.kernel.efi/4405),
> > as an efi=noruntime option?
> > 
> > On x86, due to CSM, "noefi" was a useful fallback for completely
> > broken (U)EFI implementations - but on an arm* UEFI system, there will
> > be no fallback. Could it be wrapped in a kernel hacking config option?
>  
> I don't mind making "noefi" a synonym for "efi=noruntime" on x86, as
> long as we keep "noefi" around with the same semantics it's always had.

Yeah, that would be nice.

/
    Leif
