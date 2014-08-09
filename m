Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaHIXpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 19:45:21 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:40744 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaHIXpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 19:45:20 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Peng Tao <bergwolf@gmail.com>, Kees Cook <keescook@chromium.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Mike Sampson <mike@sambodata.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: libcfs: workitem.c:  Cleaning up missing null-terminate after strncpy call
Date: Sun, 10 Aug 2014 01:46:49 +0200
Message-Id: <1407628009-24701-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/libcfs/workitem.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/libcfs/workitem.c b/drivers/staging/lustre/lustre/libcfs/workitem.c
index 0a03bf7..60326f2 100644
--- a/drivers/staging/lustre/lustre/libcfs/workitem.c
+++ b/drivers/staging/lustre/lustre/libcfs/workitem.c
@@ -365,6 +365,7 @@ cfs_wi_sched_create(char *name, struct cfs_cpt_table *cptab,
 		return -ENOMEM;
 
 	strncpy(sched->ws_name, name, CFS_WS_NAME_LEN);
+	sched->ws_name[CFS_WS_NAME_LEN - 1] = '\0';
 	sched->ws_cptab = cptab;
 	sched->ws_cpt = cpt;
 
-- 
1.7.10.4

