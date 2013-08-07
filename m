Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3HGHhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:37:42 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45635 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3HGHhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:37:39 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <libo.chen@huawei.com>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH v3 06/11] syslog_ns: use init syslog_ns for console action
Date: Wed, 7 Aug 2013 15:37:10 +0800
Message-ID: <1375861035-24320-7-git-send-email-rui.xiang@huawei.com>
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

While flags SYSLOG_ACTION_CONSOLE_ON/OFF/LEVEL of
console actin are used in syslog syscall, the related
hanlding should be targeted at host by init_syslog_ns.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 kernel/printk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/printk.c b/kernel/printk.c
index ca951e7..bdb7ed4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -373,6 +373,11 @@ static int check_syslog_permissions(int type, bool from_file,
 	if (from_file && type != SYSLOG_ACTION_OPEN)
 		return 0;
 
+	if (type == SYSLOG_ACTION_CONSOLE_OFF
+		|| type == SYSLOG_ACTION_CONSOLE_ON
+		|| type == SYSLOG_ACTION_CONSOLE_LEVEL)
+		ns = &init_syslog_ns;
+
 	if (syslog_action_restricted(type, ns)) {
 		if (ns_capable(ns->owner, CAP_SYSLOG))
 			return 0;
-- 
1.8.2.2


