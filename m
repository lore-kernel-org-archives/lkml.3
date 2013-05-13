Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3EMKQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:16:17 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41888 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3EMKQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:16:15 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Rob Herring <robherring2@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/4] ARM: Remove boilerplate debug_ll_io_init code
Date: Mon, 13 May 2013 12:16:05 +0200
Message-Id: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The recent introduction of debug_ll_io_init made possible to not rely
anymore on a custom map_io function but on debug_ll_io_init for the
early mapping and then on the various drivers to do the needed mappings for
the kernel to boot.

Some architectures begin to use only this function as the map_io callback in
the machine description.

In order to remove some boilerplate code, make the ARM mm code call
debug_ll_io_init by itself when no .map_io callback is defined.

This has been tested on the sunxi platform.

Thanks,
Maxime

Maxime Ripard (4):
  ARM: mmu: Call debug_ll_io_init if no map_io function is specified
  ARM: highbank: remove the .map_io declaration
  ARM: mxs: remove the .map_io declaration
  ARM: sunxi: Remove the .map_io function declaration

 arch/arm/mach-highbank/highbank.c |  1 -
 arch/arm/mach-mxs/mach-mxs.c      |  1 -
 arch/arm/mach-sunxi/sunxi.c       | 17 -----------------
 arch/arm/mach-sunxi/sunxi.h       | 20 --------------------
 arch/arm/mm/mmu.c                 |  2 ++
 5 files changed, 2 insertions(+), 39 deletions(-)
 delete mode 100644 arch/arm/mach-sunxi/sunxi.h

-- 
1.8.1.2

