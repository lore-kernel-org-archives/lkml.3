Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3GOOYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:24:43 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39975 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab3GOOYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:24:41 -0400
From: Julien Grall <julien.grall@linaro.org>
To: stefano.stabellini@eu.citrix.com, konrad.wilk@oracle.com
Cc: ian.campbell@citrix.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Julien Grall <julien.grall@linaro.org>
Subject: [PATCH] xen/control: protect functions with CONFIG_HIBERNATE_CALLBACKS to avoid warning
Date: Mon, 15 Jul 2013 15:24:35 +0100
Message-Id: <1373898275-15765-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_HIBERNATE_CALLBACKS is not set gcc will issue warnings:
drivers/xen/manage.c:46:13: warning: 'xen_hvm_post_suspend' defined but not used [-Wunused-function]
drivers/xen/manage.c:52:13: warning: 'xen_pre_suspend' defined but not used [-Wunused-function]
drivers/xen/manage.c:59:13: warning: 'xen_post_suspend' defined but not used [-Wunused-function]

Signed-off-by: Julien Grall <julien.grall@linaro.org>
---
 drivers/xen/manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 412b96c..7680276 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -36,6 +36,7 @@ enum shutdown_state {
 /* Ignore multiple shutdown requests. */
 static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
 
+#ifdef CONFIG_HIBERNATE_CALLBACKS
 struct suspend_info {
 	int cancelled;
 	unsigned long arg; /* extra hypercall argument */
@@ -63,7 +64,6 @@ static void xen_post_suspend(int cancelled)
 	xen_mm_unpin_all();
 }
 
-#ifdef CONFIG_HIBERNATE_CALLBACKS
 static int xen_suspend(void *data)
 {
 	struct suspend_info *si = data;
-- 
1.7.10.4

