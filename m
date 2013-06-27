Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3F0N2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:28:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:59924 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3F0N2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:28:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,952,1363132800"; 
   d="scan'208";a="32188276"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <stefano.stabellini@citrix.com>,
        <xen-devel@lists.xen.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] xen: ifdef CONFIG_HIBERNATE_CALLBACKS xen_*_suspend
Date: Thu, 27 Jun 2013 14:28:38 +0100
Message-ID: <1372339718-12102-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_hvm_post_suspend, xen_pre_suspend, xen_post_suspend are only used if
CONFIG_HIBERNATE_CALLBACKS is defined, resulting in:

drivers/xen/manage.c:46:13: warning: ‘xen_hvm_post_suspend’ defined but not used [-Wunused-function]
drivers/xen/manage.c:52:13: warning: ‘xen_pre_suspend’ defined but not used [-Wunused-function]
drivers/xen/manage.c:59:13: warning: ‘xen_post_suspend’ defined but not used [-Wunused-function]

If the kernel config is missing CONFIG_HIBERNATE_CALLBACKS.

Simply ifdef CONFIG_HIBERNATE_CALLBACKS the three functions.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 412b96c..b1005d4 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -43,6 +43,7 @@ struct suspend_info {
 	void (*post)(int cancelled);
 };
 
+#ifdef CONFIG_HIBERNATE_CALLBACKS
 static void xen_hvm_post_suspend(int cancelled)
 {
 	xen_arch_hvm_post_suspend(cancelled);
@@ -63,7 +64,6 @@ static void xen_post_suspend(int cancelled)
 	xen_mm_unpin_all();
 }
 
-#ifdef CONFIG_HIBERNATE_CALLBACKS
 static int xen_suspend(void *data)
 {
 	struct suspend_info *si = data;
-- 
1.7.2.5

