Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbbAHECi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 23:02:38 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:53257 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbbAHECh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 23:02:37 -0500
From: Chunyan Zhang <zhang.chunyan@linaro.org>
To: samuel@sortiz.org
Cc: arnd@arndb.de, zhang.lyra@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] irda: Use ktime_t instead of timeval
Date: Thu,  8 Jan 2015 12:01:26 +0800
Message-Id: <1420689692-8760-1-git-send-email-zhang.chunyan@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <driver-irda-v2>
References: <driver-irda-v2>
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
  irda: Removed all unused timeval variables
  irda: ali-ircc: Replace timeval with ktime_t
  irda: irda-usb: Replace timeval with ktime_t
  irda: nsc-ircc: Replace timeval with ktime_t
  irda: stir4200: Replace timeval with ktime_t
  irda: vlsi_ir: Replace timeval with ktime_t

 drivers/net/irda/ali-ircc.c    |   11 +++-------
 drivers/net/irda/ali-ircc.h    |    5 ++---
 drivers/net/irda/au1k_ir.c     |    3 ---
 drivers/net/irda/irda-usb.c    |   10 ++-------
 drivers/net/irda/irda-usb.h    |    5 ++---
 drivers/net/irda/kingsun-sir.c |    3 ---
 drivers/net/irda/ks959-sir.c   |    3 ---
 drivers/net/irda/mcs7780.c     |    2 --
 drivers/net/irda/mcs7780.h     |    1 -
 drivers/net/irda/nsc-ircc.c    |    7 ++----
 drivers/net/irda/nsc-ircc.h    |    5 ++---
 drivers/net/irda/stir4200.c    |   16 ++++++--------
 drivers/net/irda/via-ircc.h    |    4 ----
 drivers/net/irda/vlsi_ir.c     |   46 ++++++++++++----------------------------
 drivers/net/irda/vlsi_ir.h     |    2 +-
 15 files changed, 34 insertions(+), 89 deletions(-)

-- 
1.7.9.5

