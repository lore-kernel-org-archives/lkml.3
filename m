Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbbA2BkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:40:21 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38554 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbbA2BkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:40:18 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>, James Simmons <uja.ornl@gmail.com>,
        Greg Donald <gdonald@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: include: lustre_lib.h: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:47:06 +0100
Message-Id: <1422485227-11111-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/include/lustre_lib.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index bf13563..b80ae84 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -549,11 +549,6 @@ do {									   \
 		__blocked = cfs_block_sigsinv(0);			      \
 									       \
 	for (;;) {							     \
-		unsigned       __wstate;				       \
-									       \
-		__wstate = info->lwi_on_signal != NULL &&		      \
-			   (__timeout == 0 || __allow_intr) ?		  \
-			TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE;	       \
 									       \
 		set_current_state(TASK_INTERRUPTIBLE);		 \
 									       \
-- 
1.7.10.4

