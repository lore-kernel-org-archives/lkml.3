Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab3JKHIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:08:18 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35864 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab3JKHIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:08:15 -0400
MIME-Version: 1.0
In-Reply-To: <20131010180937.GD18821@fenchurch.internal.datastacks.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
	<20131010172844.GA26430@gmail.com>
	<20131010173710.GA18821@fenchurch.internal.datastacks.com>
	<20131010174521.GA27218@gmail.com>
	<20131010180937.GD18821@fenchurch.internal.datastacks.com>
Date: Fri, 11 Oct 2013 09:08:14 +0200
X-Google-Sender-Auth: MT8dpmGoK1cwGl0szsa4vdC2uPo
Message-ID: <CAMuHMdV8rgy=_njpXcWuZ6zkB_Lox2k0tPJy7x1Vb7ZyGN-q5g@mail.gmail.com>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Jones <pjones@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@console-pimps.org>,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 8:09 PM, Peter Jones <pjones@redhat.com> wrote:
> INTN
> GetPixelElementSize (
> IN EFI_PIXEL_BITMASK *PixelBits
> )
> {
>         INTN HighestPixel = -1;
>         INTN BluePixel;
>         INTN RedPixel;
>         INTN GreenPixel;
>         INTN RsvdPixel;
>         BluePixel = FindHighestSetBit (PixelBits->BlueMask);
>         RedPixel = FindHighestSetBit (PixelBits->RedMask);
>         GreenPixel = FindHighestSetBit (PixelBits->GreenMask);
>         RsvdPixel = FindHighestSetBit (PixelBits->ReservedMask);
>         HighestPixel = max (BluePixel, RedPixel);
>         HighestPixel = max (HighestPixel, GreenPixel);
>         HighestPixel = max (HighestPixel, RsvdPixel);
>         return HighestPixel;
> }
> EFI_PHYSICAL_ADDRESS NewPixelAddress;
> EFI_PHYSICAL_ADDRESS CurrentPixelAddress;
> EFI_GRAPHICS_OUTPUT_MODE_INFORMATION OutputInfo;
> INTN PixelElementSize;
>
> switch (OutputInfo.PixelFormat) {
>         case PixelBitMask:
>                 PixelElementSize = GetPixelElementSize (&OutputInfo.PixelInformation);

So this can be less than 32.

>                 break;
>         case PixelBlueGreenRedReserved8BitPerColor:
>         case PixelRedGreenBlueReserved8BitPerColor:
>                 PixelElementSize = sizeof (EFI_GRAPHICS_OUTPUT_BLT_PIXEL);
>                 break;
> }
>
> Which makes this painfully clear.
>
>> Also, the main question would be, what is the typical value for
>> si->lfb_depth. 32 on almost all EFI systems? All around the map? Depends
>> on what graphics state the EFI bootloader passes us?
>
> Yes, 32 on almost all systems that implement a framebuffer console at
> all.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
