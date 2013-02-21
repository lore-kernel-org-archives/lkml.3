Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3BURP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:15:56 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:40271 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3BURPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:15:55 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: =?UTF8?q?=5BPATCHv2=2000/10=5D=20remoteproc=3A=20Support=20bi-directional=20vdev=20config=20space?=
Date: Thu, 21 Feb 2013 18:15:30 +0100
Message-Id: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF8
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

Changes since v1:
- Address all of Ido's review comments on the previous patch-set.

Thanks,
Sjur

Dmitry Tarnyagin (1):
  remoteproc: Bugfix: Deallocate firmware image on shutdown

Sjur Brændeland (9):
  remoteproc: Bugfix remove entry from list before freeing it
  remoteproc: Refactor function rproc_elf_find_rsc_table
  remoteproc: Parse ELF file to find resource table address
  remoteproc: Parse STE-firmware and find resource table address
  remoteproc: Code cleanup of resource parsing
  remoteproc: Calculate max_notifyid by counting vrings
  remoteproc: Always perserve resource table data
  remoteproc: Support virtio config space.
  remoteproc: Set vring addresses in resource table

 drivers/remoteproc/Kconfig                 |    1 +
 drivers/remoteproc/remoteproc_core.c       |  185 +++++++++++++++++----------
 drivers/remoteproc/remoteproc_elf_loader.c |   92 +++++++++-----
 drivers/remoteproc/remoteproc_internal.h   |   13 ++
 drivers/remoteproc/remoteproc_virtio.c     |   61 +++++++---
 drivers/remoteproc/ste_modem_rproc.c       |   52 ++++++---
 include/linux/remoteproc.h                 |   13 ++-
 7 files changed, 283 insertions(+), 134 deletions(-)

-- 
1.7.5.4

