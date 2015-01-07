Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbbAGDkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:40:46 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41916 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbbAGDkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 22:40:45 -0500
From: Chunyan Zhang <zhang.chunyan@linaro.org>
To: samuel@sortiz.org
Cc: arnd@linaro.org, zhang.lyra@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] driver/net/irda: Use ktime_t instead of timeval
Date: Wed,  7 Jan 2015 11:39:32 +0800
Message-Id: <1420601978-15866-1-git-send-email-zhang.chunyan@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <driver-irda>
References: <driver-irda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set removed all uses of timeval and used ktime_t instead if
needed, since 32-bit time types will break in the year 2038.

This patch-set also used the ktime_xxx functions accordingly.
e.g.
* Used ktime_get to get the current time instead of do_gettimeofday.
* And, used ktime_us_delta to get the elapsed time directly.

Chunyan Zhang (6):
  driver/net/irda: Removed all unused timeval variables
  driver/net/irda: Replace timeval with ktime_t in ali-ircc
  driver/net/irda: Replace timeval with ktime_t in irda-usb
  driver/net/irda: Replace timeval with ktime_t in nsc-ircc
  driver/net/irda: Replace timeval with ktime_t in stir4200
  driver/net/irda: Replace timeval with ktime_t in vlsi_ir

 drivers/net/irda/ali-ircc.c    |   12 ++++------
 drivers/net/irda/ali-ircc.h    |    6 ++---
 drivers/net/irda/au1k_ir.c     |    3 ---
 drivers/net/irda/irda-usb.c    |   11 +++------
 drivers/net/irda/irda-usb.h    |    6 ++---
 drivers/net/irda/kingsun-sir.c |    3 ---
 drivers/net/irda/ks959-sir.c   |    3 ---
 drivers/net/irda/mcs7780.c     |    2 --
 drivers/net/irda/mcs7780.h     |    1 -
 drivers/net/irda/nsc-ircc.c    |    8 +++----
 drivers/net/irda/nsc-ircc.h    |    6 ++---
 drivers/net/irda/stir4200.c    |   18 +++++++-------
 drivers/net/irda/via-ircc.h    |    4 ----
 drivers/net/irda/vlsi_ir.c     |   51 ++++++++++++++--------------------------
 drivers/net/irda/vlsi_ir.h     |    2 +-
 15 files changed, 46 insertions(+), 90 deletions(-)

-- 
1.7.9.5

