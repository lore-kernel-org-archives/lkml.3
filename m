Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaI2Q0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:26:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbaI2Q0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:26:11 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH v5 0/5] AHCI: Optimize interrupt processing in multi-MSI mode
Date: Mon, 29 Sep 2014 18:25:56 +0200
Message-Id: <cover.1412007152.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v4:
  - CONFIG_SATA_HIGHBANK platform build error fixed;
  - code movement (from ahci.c to libahci.c) separated from other changes;

Changes since v3:
  - series rebased on libata/for-3.18;
  - single IRQ interrupt update removed, along with patches 4,5
    "AHCI: Get rid of redundant arg to ahci_handle_port_interrupt()"
    "AHCI: Optimize single IRQ interrupt processing" removed;
  - multi-MSI updated to skip zero value port status;

Changes since v2:
  - single patch split in a series;
  - benchmarking statistics reworded;
  - HOST_IRQ_STAT reg optimization added (patch 6);

Cc: linux-ide@vger.kernel.org

Alexander Gordeev (5):
  AHCI: Pass SCSI host template as arg to ahci_host_activate()
  AHCI: Move ahci_host_activate() function to libahci.c
  AHCI: Move host activation code into ahci_host_activate()
  AHCI: Make few function names more descriptive
  AHCI: Do not read HOST_IRQ_STAT reg in multi-MSI mode

 drivers/ata/acard-ahci.c       |   3 +-
 drivers/ata/ahci.c             |  66 +-----------------
 drivers/ata/ahci.h             |   8 +--
 drivers/ata/libahci.c          | 149 +++++++++++++++++++++++------------------
 drivers/ata/libahci_platform.c |   3 +-
 drivers/ata/sata_highbank.c    |   3 +-
 6 files changed, 92 insertions(+), 140 deletions(-)

-- 
1.8.3.1

