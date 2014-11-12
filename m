Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaKLOnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:43:10 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50228 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752357AbaKLOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:43:08 -0500
From: Sudeep Holla <sudeep.holla@arm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] drivers/base: cacheinfo: remove noisy error boot message
Date: Wed, 12 Nov 2014 14:42:53 +0000
Message-Id: <1415803373-7429-1-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems that don't support cacheinfo, this error message can be
considered noisy and irrelevant. The error messages can be added to
the functions that architectures implement overiding the weak default
definition if really required.

This patch removes the concerned error message in the generic code.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Reported-by: Fabio Estevam <festevam@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/cacheinfo.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Hi Greg,

Since I always tested the series only on the architectures supporting
cacheinfo, I failed to see that this error message is thrown out at the
boot time if the architecture doesn't support it.

Can you pick up this small fix to avoid noisy error message ?

Regards,
Sudeep

diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
index 8ed4ea1f3716..6e64563361f0 100644
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -520,10 +520,8 @@ static int __init cacheinfo_sysfs_init(void)
 
 	for_each_online_cpu(cpu) {
 		rc = detect_cache_attributes(cpu);
-		if (rc) {
-			pr_err("error detecting cacheinfo..cpu%d\n", cpu);
+		if (rc)
 			goto out;
-		}
 		rc = cache_add_dev(cpu);
 		if (rc) {
 			free_cache_attributes(cpu);
-- 
1.9.1

