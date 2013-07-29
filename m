Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab3G2CfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 22:35:20 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:38483 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3G2CfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 22:35:15 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <libo.chen@huawei.com>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 6/9] syslog_ns: use init syslog_ns for console action
Date: Mon, 29 Jul 2013 10:31:17 +0800
Message-ID: <1375065080-26740-7-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com>
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com>
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
index c5c65a8..fd2d600 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -379,6 +379,11 @@ static int check_syslog_permissions(int type, bool from_file,
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


