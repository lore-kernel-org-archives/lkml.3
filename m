Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031Ab3IGCoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 22:44:39 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:42442 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3IGCoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 22:44:38 -0400
MIME-Version: 1.0
Date: Fri, 6 Sep 2013 22:44:33 -0400
X-Google-Sender-Auth: -ToTppgTpzOGmgw6dNT9hdtq28A
Message-ID: <CA+5PVA6iUcY+DCh51R_uwxZ1BOGrS-8-OfaFTF6Bwz9JFDVcUQ@mail.gmail.com>
Subject: crypto/xor.ko fails to build with CONFIG_KERNEL_MODE_NEON=y
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We enabled CONFIG_KERNEL_MODE_NEON on the armv7hl builds we're doing.
It builds for a while, but eventually fails when running modpost on
the xor.ko module:

ERROR: "xor_block_neon_inner" [crypto/xor.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

I tried adding an EXPORT_SYMBOL_GPL(xor_block_neon_inner); after the
structure definition in arch/arm/lib/xor-neon.c but that doesn't seem
to have done anything.

Before I go chasing this further, I'm curious if anyone else has run into this.

josh
