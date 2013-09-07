Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750950Ab3IGF4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 01:56:32 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:38764 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3IGF4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 01:56:31 -0400
References: <CA+5PVA6iUcY+DCh51R_uwxZ1BOGrS-8-OfaFTF6Bwz9JFDVcUQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <CA+5PVA6iUcY+DCh51R_uwxZ1BOGrS-8-OfaFTF6Bwz9JFDVcUQ@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <645D2350-5007-4EFF-AFFD-8D51BA006292@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (10B329)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: crypto/xor.ko fails to build with CONFIG_KERNEL_MODE_NEON=y
Date: Sat, 7 Sep 2013 07:56:26 +0200
To: Josh Boyer <jwboyer@fedoraproject.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 7 sep. 2013, at 04:44, Josh Boyer <jwboyer@fedoraproject.org> wrote:

> We enabled CONFIG_KERNEL_MODE_NEON on the armv7hl builds we're doing.
> It builds for a while, but eventually fails when running modpost on
> the xor.ko module:
> 
> ERROR: "xor_block_neon_inner" [crypto/xor.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 

Clearly a bug, thanks for spotting this. I will submit a fix asap. In the mean time, building the xor code into the zImage will help you complete the build.

> I tried adding an EXPORT_SYMBOL_GPL(xor_block_neon_inner); after the
> structure definition in arch/arm/lib/xor-neon.c but that doesn't seem
> to have done anything.
> 

I would expected that to have done the trick, but perhaps it is better to merge the neon code into the main arm/xor source file.

> Before I go chasing this further, I'm curious if anyone else has run into this.
> 

Cheers,
Ard.



> josh
