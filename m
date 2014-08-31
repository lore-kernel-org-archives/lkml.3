Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaHaJxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 05:53:52 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53216 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaHaJxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 05:53:49 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lnet: lib-ptl.c: sparsa warning: symbol not declared
Date: Sun, 31 Aug 2014 15:23:35 +0530
Message-Id: <1409478815-6636-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning of following symbol not declared:
warning: symbol 'lnet_ptl_cleanup' was not declared. Should it be static?
warning: symbol 'lnet_ptl_setup' was not declared. Should it be static?



Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

As of now these functions are not being called from any other file, so i guess its safe to make them static. 

 drivers/staging/lustre/lnet/lnet/lib-ptl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-ptl.c b/drivers/staging/lustre/lnet/lnet/lib-ptl.c
index 91767c9..720c73b 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-ptl.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-ptl.c
@@ -712,7 +712,7 @@ lnet_ptl_attach_md(lnet_me_t *me, lnet_libmd_t *md,
 	lnet_ptl_unlock(ptl);
 }
 
-void
+static void
 lnet_ptl_cleanup(struct lnet_portal *ptl)
 {
 	struct lnet_match_table	*mtable;
@@ -750,7 +750,7 @@ lnet_ptl_cleanup(struct lnet_portal *ptl)
 	ptl->ptl_mtables = NULL;
 }
 
-int
+static int
 lnet_ptl_setup(struct lnet_portal *ptl, int index)
 {
 	struct lnet_match_table	*mtable;
-- 
1.8.1.2

