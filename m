Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaFFKmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:42:09 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62725 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaFFKmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:42:05 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, pebolle@tiscali.nl, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, horms@verge.net.au, geert@linux-m68k.org,
        laurent.pinchart@ideasonboard.com, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.carpenter@oracle.com
Date: Fri, 06 Jun 2014 19:44:08 +0900
Message-Id: <20140606104408.4423.36098.sendpatchset@w520>
Subject: [PATCH v3 00/05] staging: Emma Mobile USB driver and KZM9D board code V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

staging: Emma Mobile USB driver and KZM9D board code V3

[PATCH v3 01/05] staging: emxx_udc: Add Emma Mobile USB Gadget driver
[PATCH v3 02/05] staging: emxx_udc: I/O memory and IRQ resource support
[PATCH v3 03/05] staging: emxx_udc: Add TODO file
[PATCH v3 04/05] staging: board: Initial board staging support
[PATCH v3 05/05] staging: board: kzm9d: Board staging support for emxx_udc

This patch series is V3 of the old USB Gadget driver for Emma Mobile
that gets slightly adjusted to make use of the platform device interface
which in turn is used to add USB Gadget support to the KZM9D board.

Two separate staging components are included in this series:
1) the emxx_udc driver - from out-of-tree Android 2.6.35.7
2) board staging support for KZM9D - platform device for DT-only KZM9D

The two components above will be used to continously improve the driver
and board integration code until the driver can be moved out of staging
and/or DT bindings are available so the board staging platform device code
can be replaced with a DT node.

Changes since V2:
- Added CONFIG_OF_ADDRESS dependency for the board staging bits

Changes since V1:
- Added TODO file for emxx_udc
- Broke out board staging base support, included TODO file
- Added code to avoid registering platform device if DT node exists
- Modified KZM9D board code build condition to use SoC Kconfig entry

Many thanks to Dan Carpenter, Geert Uytterhoeven, Greg KH and
Paul Bolle for feedback!

Please let me know if you would like me to rebase this code somehow.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 Written against renesas git repo at kernel.org using tag
 renesas-devel-v3.15-rc8-20140606

 drivers/staging/Kconfig             |    4 
 drivers/staging/Makefile            |    2 
 drivers/staging/board/Kconfig       |    8 
 drivers/staging/board/Makefile      |    2 
 drivers/staging/board/TODO          |    2 
 drivers/staging/board/board.c       |   41 
 drivers/staging/board/board.h       |   20 
 drivers/staging/board/kzm9d.c       |   19 
 drivers/staging/emxx_udc/Kconfig    |   10 
 drivers/staging/emxx_udc/Makefile   |    1 
 drivers/staging/emxx_udc/TODO       |    4 
 drivers/staging/emxx_udc/emxx_udc.c | 3616 ++++++++++++++++++++++++++++++++++-
 drivers/staging/emxx_udc/emxx_udc.h |  671 ++++++
 13 files changed, 4352 insertions(+), 48 deletions(-)
