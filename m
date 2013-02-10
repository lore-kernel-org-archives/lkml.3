Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3BJLjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 06:39:24 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:61287 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3BJLjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 06:39:23 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 0/9] remoteproc: Support bi-directional vdev config space
Date: Sun, 10 Feb 2013 12:39:03 +0100
Message-Id: <1360496352-29482-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

This patch-set adds support for shared resource table between
Linux kernel and remote devices.
- dynamically-allocated address of the vrings can be communicated
- vdev statuses can be communicated
- virtio config space becomes bi-directional
- virtio feature negotiation is two-way
- max_nofiyid is reported correctly

No device firmware changes are required for this patch-set.

Cheers,
Sjur

Dmitry Tarnyagin (1):
  remoteproc: Bugfix: Deallocate firmware image on shutdown

Sjur Brændeland (8):
  remoteproc: Refactor function rproc_elf_find_rsc_table
  remoteproc: Parse ELF file to find resource table address
  remoteproc: Parse STE-firmware and find resource table address
  remoteproc: Set vring addresses in resource table
  remoteproc: Support virtio config space.
  remoteproc: Code cleanup of resource parsing
  remoteproc: Calculate max_notifyid by counting vrings
  remoteproc: Always perserve resource table data

 drivers/remoteproc/remoteproc_core.c       |  146 ++++++++++++++++------------
 drivers/remoteproc/remoteproc_elf_loader.c |   96 +++++++++++++------
 drivers/remoteproc/remoteproc_internal.h   |   13 +++
 drivers/remoteproc/remoteproc_virtio.c     |   38 +++++++-
 drivers/remoteproc/ste_modem_rproc.c       |   50 +++++++---
 include/linux/remoteproc.h                 |    7 +-
 6 files changed, 240 insertions(+), 110 deletions(-)

-- 
1.7.5.4

