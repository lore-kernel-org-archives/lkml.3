Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbbAPBo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:44:57 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53311 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbbAPBo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:44:56 -0500
From: Jia He <hejianet@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jia He <hejianet@gmail.com>, Jeremiah Mahler <jmmahler@gmail.com>,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] staging: lustre: libcfs: fix sparse warnings about static declaration
Date: Fri, 16 Jan 2015 09:45:46 +0800
Message-Id: <1421372747-2954-1-git-send-email-hejianet@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20150114063518.GA18644@hudson.localdomain>
References: <20150114063518.GA18644@hudson.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions aren't used outside of this file so making them static
to suppress the sparse warnings about static declaration.

Signed-off-by: Jia He <hejianet@gmail.com>
Cc: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/lustre/lustre/libcfs/module.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/module.c b/drivers/staging/lustre/lustre/libcfs/module.c
index 2c4fc74..b9ee37c 100644
--- a/drivers/staging/lustre/lustre/libcfs/module.c
+++ b/drivers/staging/lustre/lustre/libcfs/module.c
@@ -42,8 +42,7 @@
 #include "../../include/linux/lnet/lnet.h"
 #include "tracefile.h"
 
-void
-kportal_memhog_free (struct libcfs_device_userstate *ldu)
+static void kportal_memhog_free (struct libcfs_device_userstate *ldu)
 {
 	struct page **level0p = &ldu->ldu_memhog_root_page;
 	struct page **level1p;
@@ -86,8 +85,7 @@ kportal_memhog_free (struct libcfs_device_userstate *ldu)
 	LASSERT (ldu->ldu_memhog_pages == 0);
 }
 
-int
-kportal_memhog_alloc(struct libcfs_device_userstate *ldu, int npages,
+static int kportal_memhog_alloc(struct libcfs_device_userstate *ldu, int npages,
 		     gfp_t flags)
 {
 	struct page **level0p;
-- 
1.9.1

