Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaLCCfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:35:48 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:58062 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750891AbaLCCfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:35:46 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44389217"
Message-ID: <547E7357.9040606@cn.fujitsu.com>
Date: Wed, 3 Dec 2014 10:20:07 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: <linux-mtd@lists.infradead.org>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <linux-kernel@vger.kernel.org>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [RESEND PATCH 2/3] mtd: move the enum definition out of struct mtdblk_dev
References: <1417052709-22026-1-git-send-email-guz.fnst@cn.fujitsu.com>
In-Reply-To: <1417052709-22026-1-git-send-email-guz.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the enum definition out of struct mtdblk_dev, just cleanup.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/mtd/mtdblock.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index bb4c14f..acc00f1 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -34,6 +34,11 @@
 #include <linux/mutex.h>
 #include <linux/major.h>
 
+enum CACHE_STATES {
+	STATE_EMPTY,
+	STATE_CLEAN,
+	STATE_DIRTY
+};
 
 struct mtdblk_dev {
 	struct mtd_blktrans_dev mbd;
@@ -42,7 +47,7 @@ struct mtdblk_dev {
 	unsigned char *cache_data;
 	unsigned long cache_offset;
 	unsigned int cache_size;
-	enum { STATE_EMPTY, STATE_CLEAN, STATE_DIRTY } cache_state;
+	enum CACHE_STATES cache_state;
 };
 
 /*
-- 
1.7.7

.

