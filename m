Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3LCTbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:31:32 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:33148 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3LCTba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:31:30 -0500
MIME-Version: 1.0
In-Reply-To: <20131203183844.GA22668@mudshark.cambridge.arm.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
	<1385762712-17043-2-git-send-email-msalter@redhat.com>
	<20131203183844.GA22668@mudshark.cambridge.arm.com>
Date: Tue, 3 Dec 2013 11:31:29 -0800
Message-ID: <CAFECyb-jx=f4T=NARGhGVJjQXGX1t4n8YbWuzJ050O4AQY2p4Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
From: Roy Franz <roy.franz@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Salter <msalter@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 10:38 AM, Will Deacon <will.deacon@arm.com> wrote:
> Hi Mark, Roy,
>
> On Fri, Nov 29, 2013 at 10:05:10PM +0000, Mark Salter wrote:
>> This patch adds PE/COFF header fields to the start of the Image
>> so that it appears as an EFI application to EFI firmware. An EFI
>> stub is included to allow direct booting of the kernel Image. Due
>> to EFI firmware limitations, only little endian kernels with 4K
>> page sizes are supported at this time. Support in the COFF header
>> for signed images was provided by Ard Biesheuvel.
>
> I haven't really jumped into this but, whilst I see the use of EFI_STUB on
> both arm and arm64, there seems to be some duplication/reinvention between
> the two series you've put together.
>
> Maybe I'm just being ignorant, but the stuff in efi-stub.c really looks to
> be doing the same thing on both architectures. Would you guys be able to
> work to together to produce an independent series containing the common
> parts, then add arm/arm64 backends on top of that please? In particular,
> factoring out the device-tree parts ensures that we don't introduce subtle
> differences between the two architectures when there's no real need to do
> so...
>
> ...or shout at me because I didn't understand what you were doing!
>
> Cheers,
>
> Will

Hi Will,

   Some of the device tree code is already factored out in
drivers/firmware/efi/fdt.c, but
looking at this again I think that there is more that can be moved to
common code.  The
main difference between the arm/arm64 stubs is the restrictions on
where the kernel binary
can be loaded.  On arm64 it is the kernel image itself, and on arm it
is the zImage that is the
next stage.  This also affects the build environment - the arm64 stub
is part of the kernel itself,
and the arm stub is part of the decompressor.
I'll work with Mark to see how much of the two stubs we can refactor
into shared code.

Roy
