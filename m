Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaIUNTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:19:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaIUNTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:19:47 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH RESEND v3 0/6] AHCI: Optimize interrupt processing
Date: Sun, 21 Sep 2014 15:19:23 +0200
Message-Id: <cover.1411297686.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Tejun's feedback I am sending v3.

Changes since v2:
  - single patch split in a series;
  - benchmarking statistics reworded;
  - HOST_IRQ_STAT reg optimization added (patch 6);

Cc: linux-ide@vger.kernel.org

Alexander Gordeev (6):
  AHCI: Cleanup checking of multiple MSIs/SLM modes
  AHCI: Move host activation code into ahci_host_activate()
  AHCI: Make few function names more descriptive
  AHCI: Get rid of redundant arg to ahci_handle_port_interrupt()
  AHCI: Optimize single IRQ interrupt processing
  AHCI: Do not read HOST_IRQ_STAT reg in multi-MSI mode

 drivers/ata/acard-ahci.c       |   3 +-
 drivers/ata/ahci.c             | 101 +++++++++++++++++++++++------------
 drivers/ata/ahci.h             |  10 ++--
 drivers/ata/libahci.c          | 117 +++++++++++++++++------------------------
 drivers/ata/libahci_platform.c |   3 +-
 5 files changed, 123 insertions(+), 111 deletions(-)

-- 
1.8.3.1

