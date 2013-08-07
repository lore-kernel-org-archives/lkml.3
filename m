Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab3HGHiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:38:04 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:44921 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab3HGHiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:38:00 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <libo.chen@huawei.com>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH v3 05/11] syslog_ns: make permisiion check per user namespace
Date: Wed, 7 Aug 2013 15:37:09 +0800
Message-ID: <1375861035-24320-6-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ns_capable to check capability in user ns,
instead of capable function. The user ns is the
owner of current syslog ns.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 kernel/printk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index e508ab2..ca951e7 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -374,13 +374,13 @@ static int check_syslog_permissions(int type, bool from_file,
 		return 0;
 
 	if (syslog_action_restricted(type, ns)) {
-		if (capable(CAP_SYSLOG))
+		if (ns_capable(ns->owner, CAP_SYSLOG))
 			return 0;
 		/*
 		 * For historical reasons, accept CAP_SYS_ADMIN too, with
 		 * a warning.
 		 */
-		if (capable(CAP_SYS_ADMIN)) {
+		if (ns_capable(ns->owner, CAP_SYS_ADMIN)) {
 			pr_warn_once("%s (%d): Attempt to access syslog with "
 				     "CAP_SYS_ADMIN but no CAP_SYSLOG "
 				     "(deprecated).\n",
-- 
1.8.2.2


