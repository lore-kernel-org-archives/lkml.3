Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaDVFdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:33:00 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48043 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaDVFc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:32:57 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: james.l.morris@oracle.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        nasa4836@gmail.com
Subject: [PATCH] device_cgroup: explicitly init the early_init field
Date: Tue, 22 Apr 2014 13:32:49 +0800
Message-Id: <1398144769-9938-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a cgroup subsystem who should init early, then it should carefully
take care of the implementation of css_alloc, because it will be called
before mm_init() setup the world.

Luckily we don't, and we better explicitly assign the early_init field
to 0, for document reason.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 security/device_cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 8365909..dd9614f 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -688,6 +688,7 @@ struct cgroup_subsys devices_cgrp_subsys = {
 	.css_online = devcgroup_online,
 	.css_offline = devcgroup_offline,
 	.base_cftypes = dev_cgroup_files,
+	.early_init = 0,
 };
 
 /**
-- 
2.0.0-rc0

