Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbaLKUF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:05:56 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:6006 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732AbaLKUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:05:55 -0500
From: Sifan Naeem <sifan.naeem@imgtec.com>
To: <james.hogan@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>,
        Sifan Naeem <sifan.naeem@imgtec.com>
Subject: [PATCH v2 0/5] rc: img-ir: rc5 and rc6 support added
Date: Thu, 11 Dec 2014 20:06:21 +0000
Message-ID: <1418328386-9802-1-git-send-email-sifan.naeem@imgtec.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.167.63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets adds support for rc5 and rc6 decoder modules along with
workarounds for quirks in the hw which surfaces when decoding in 
biphase mode required by rc5 and rc6.

Changes from v1:
 * Typo Corrected in the commit message
 * Rebased due to conflict with "img-ir/hw: Fix potential deadlock stopping timer"
 * spinlock taken in img_ir_suspend_timer
 * Check for hw->stopping before handling quirks in img_ir_isr_hw
 * New member added to img_ir_priv_hw to save irq status over suspend
 * Phillips renamed to Philips

Sifan Naeem (5):
  rc: img-ir: add scancode requests to a struct
  rc: img-ir: pass toggle bit to the rc driver
  rc: img-ir: biphase enabled with workaround
  rc: img-ir: add philips rc5 decoder module
  rc: img-ir: add philips rc6 decoder module

 drivers/media/rc/img-ir/Kconfig        |   15 ++++
 drivers/media/rc/img-ir/Makefile       |    2 +
 drivers/media/rc/img-ir/img-ir-hw.c    |   84 ++++++++++++++++++++---
 drivers/media/rc/img-ir/img-ir-hw.h    |   24 ++++++-
 drivers/media/rc/img-ir/img-ir-jvc.c   |    8 +--
 drivers/media/rc/img-ir/img-ir-nec.c   |   24 +++----
 drivers/media/rc/img-ir/img-ir-rc5.c   |   88 ++++++++++++++++++++++++
 drivers/media/rc/img-ir/img-ir-rc6.c   |  117 ++++++++++++++++++++++++++++++++
 drivers/media/rc/img-ir/img-ir-sanyo.c |    8 +--
 drivers/media/rc/img-ir/img-ir-sharp.c |    8 +--
 drivers/media/rc/img-ir/img-ir-sony.c  |   12 ++--
 11 files changed, 348 insertions(+), 42 deletions(-)
 create mode 100644 drivers/media/rc/img-ir/img-ir-rc5.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-rc6.c

-- 
1.7.9.5

