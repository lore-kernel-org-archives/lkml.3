Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3BNDFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:05:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19977 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab3BNDFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 15/16] ramster: Fix compile warnings due to usage of debugfs_create_size_t
Date: Wed, 13 Feb 2013 22:05:05 -0500
Message-Id: <1360811106-2679-16-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We get tons of "note: expected ‘size_t *’ but argument is of type ‘long
int *’" warnings. This fixes it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/ramster/ramster.c | 34 ++++++++++++++++----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/zcache/ramster/ramster.c b/drivers/staging/zcache/ramster/ramster.c
index c06709f..bf96a1c 100644
--- a/drivers/staging/zcache/ramster/ramster.c
+++ b/drivers/staging/zcache/ramster/ramster.c
@@ -67,25 +67,25 @@ static int ramster_remote_target_nodenum __read_mostly = -1;
 static long ramster_flnodes;
 static atomic_t ramster_flnodes_atomic = ATOMIC_INIT(0);
 static unsigned long ramster_flnodes_max;
-static long ramster_foreign_eph_pages;
+static ssize_t ramster_foreign_eph_pages;
 static atomic_t ramster_foreign_eph_pages_atomic = ATOMIC_INIT(0);
-static unsigned long ramster_foreign_eph_pages_max;
-static long ramster_foreign_pers_pages;
+static ssize_t ramster_foreign_eph_pages_max;
+static ssize_t ramster_foreign_pers_pages;
 static atomic_t ramster_foreign_pers_pages_atomic = ATOMIC_INIT(0);
-static unsigned long ramster_foreign_pers_pages_max;
-static unsigned long ramster_eph_pages_remoted;
-static unsigned long ramster_pers_pages_remoted;
-static unsigned long ramster_eph_pages_remote_failed;
-static unsigned long ramster_pers_pages_remote_failed;
-static unsigned long ramster_remote_eph_pages_succ_get;
-static unsigned long ramster_remote_pers_pages_succ_get;
-static unsigned long ramster_remote_eph_pages_unsucc_get;
-static unsigned long ramster_remote_pers_pages_unsucc_get;
-static unsigned long ramster_pers_pages_remote_nomem;
-static unsigned long ramster_remote_objects_flushed;
-static unsigned long ramster_remote_object_flushes_failed;
-static unsigned long ramster_remote_pages_flushed;
-static unsigned long ramster_remote_page_flushes_failed;
+static ssize_t ramster_foreign_pers_pages_max;
+static ssize_t ramster_eph_pages_remoted;
+static ssize_t ramster_pers_pages_remoted;
+static ssize_t ramster_eph_pages_remote_failed;
+static ssize_t ramster_pers_pages_remote_failed;
+static ssize_t ramster_remote_eph_pages_succ_get;
+static ssize_t ramster_remote_pers_pages_succ_get;
+static ssize_t ramster_remote_eph_pages_unsucc_get;
+static ssize_t ramster_remote_pers_pages_unsucc_get;
+static ssize_t ramster_pers_pages_remote_nomem;
+static ssize_t ramster_remote_objects_flushed;
+static ssize_t ramster_remote_object_flushes_failed;
+static ssize_t ramster_remote_pages_flushed;
+static ssize_t ramster_remote_page_flushes_failed;
 /* FIXME frontswap selfshrinking knobs in debugfs? */
 
 #ifdef CONFIG_DEBUG_FS
-- 
1.8.0.2

