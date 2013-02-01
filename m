Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab3BAUxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:53:55 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:47628 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645Ab3BAUwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:52:44 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        rcj@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 15/16] ramster: Fix compile warnings due to usage of debugfs_create_size_t
Date: Fri,  1 Feb 2013 15:52:18 -0500
Message-Id: <1359751939-23584-16-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359751939-23584-1-git-send-email-konrad.wilk@oracle.com>
References: <1359751939-23584-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 491ec70..4f715c7 100644
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
1.7.11.7

