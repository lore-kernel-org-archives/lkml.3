Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617Ab3JPLnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:43:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52871 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3JPLnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:43:03 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tj@kernel.org>
CC: <sergei.shtylyov@cogentembedded.com>, <kishon@ti.com>,
        <b.zolnierkie@samsung.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 0/2]  ata: ahci_platform: Add PHY support and OMAP support
Date: Wed, 16 Oct 2013 14:42:51 +0300
Message-ID: <1381923773-10596-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some platforms have a PHY hooked up to the SATA controller.
The PHY needs to be initialized and powered up for SATA to work.
We do that using the Generic PHY framework. [1]. This is done
in PATCH 1

In order to support SATA on the OMAP platforms we need to runtime
resume the device before use. PATCH 2 takes care of that.

Changelog:
v2:
- got rid of Texas Instruments SATA wrapper driver
- adressed review comments

cheers,
-roger

[1] - The Generic PHY framework is available in Greg KH's usb-next branch.
  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git  usb-next

---
Balaji T K (1):
  ata: ahci_platform: Manage SATA PHY

Roger Quadros (1):
  ata: ahci_platform: runtime resume the device before use

 .../devicetree/bindings/ata/ahci-platform.txt      |    3 +-
 drivers/ata/ahci.h                                 |    2 +
 drivers/ata/ahci_platform.c                        |   41 +++++++++++++++++++-
 3 files changed, 44 insertions(+), 2 deletions(-)

-- 
1.7.9.5

