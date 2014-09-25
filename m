Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaIYNNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:13:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaIYNNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:13:39 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v4 0/4] AHCI: Optimize interrupt processing in multi-MSI mode
Date: Thu, 25 Sep 2014 15:13:20 +0200
Message-Id: <cover.1411648623.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Alexander Gordeev (4):
  AHCI: Cleanup checking of multiple MSIs/SLM modes
  AHCI: Move host activation code into ahci_host_activate()
  AHCI: Make few function names more descriptive
  AHCI: Do not read HOST_IRQ_STAT reg in multi-MSI mode

 drivers/ata/acard-ahci.c       |   3 +-
 drivers/ata/ahci.c             |  80 ++---------------------
 drivers/ata/ahci.h             |   7 +-
 drivers/ata/libahci.c          | 145 ++++++++++++++++++++++++++---------------
 drivers/ata/libahci_platform.c |   3 +-
 5 files changed, 102 insertions(+), 136 deletions(-)

-- 
1.8.3.1

