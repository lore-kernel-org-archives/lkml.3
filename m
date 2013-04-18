Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967730Ab3DRKMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:12:35 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:34402 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967716Ab3DRKMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:12:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 00/32] dmaengine: Refactor the DMA40 driver
Date: Thu, 18 Apr 2013 11:11:42 +0100
Message-Id: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aim of this patch-set is to refactor the DMA40 and its clients to
use the DMA APIs in the correct manor. It also encompasses a few
cleanups along the way.

When a client requests a channel, the driver should only do very basic
channel configuration, as the information passed from clients is very
limited at this stage. Instead, channels should be configured during a
separate call which is invoked after a channel number has been assigned.
This patch-set ensures that only the basic amount of configuration is
attempted at allocation time. By doing this, we're also allowing DMA
configuration to originate from Device Tree.

This process is ongoing, as there is still one outstanding client
waiting to be converted. The MSP (Audio) driver's DMA routines have
recently been adapted to this new way of doing things. Some patches
have been accepted, others are still on the lists. Once they have
all been applied, I can continue the refactoring process.

Ideally, I'd like this patch-set to go in order, as a full patch-set.
As to which tree it should go though, I don't have any strong
preference.

 Documentation/devicetree/bindings/dma/ste-dma40.txt |   66 ++++++++++++++++
 arch/arm/boot/dts/dbx5x0.dtsi                       |   46 ++++++++++-
 arch/arm/mach-ux500/board-mop500-audio.c            |   56 ++------------
 arch/arm/mach-ux500/board-mop500-sdi.c              |   40 ++--------
 arch/arm/mach-ux500/board-mop500.c                  |   49 +++---------
 arch/arm/mach-ux500/board-mop500.h                  |    1 +
 arch/arm/mach-ux500/cpu-db8500.c                    |   60 +++++----------
 arch/arm/mach-ux500/devices-db8500.c                |  163 +++++++++++++++------------------------
 arch/arm/mach-ux500/ste-dma40-db8500.h              |  193 ++++++++++++++++------------------------------
 arch/arm/mach-ux500/usb.c                           |   10 +--
 drivers/dma/ste_dma40.c                             |  376 ++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------
 drivers/dma/ste_dma40_ll.c                          |  112 +++++++++++++--------------
 drivers/dma/ste_dma40_ll.h                          |    5 +-
 include/linux/platform_data/dma-ste-dma40.h         |   16 +---
 14 files changed, 574 insertions(+), 619 deletions(-)




