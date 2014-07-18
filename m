Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbaGRKjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:39:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761230AbaGRKiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:38:12 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Fabian Frederick <fabf@skynet.be>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/8] GFS2: replace count*size kzalloc by kcalloc
Date: Fri, 18 Jul 2014 11:37:41 +0100
Message-Id: <1405679865-15728-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
References: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

kcalloc manages count*sizeof overflow.

Cc: cluster-devel@redhat.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 91f274d..4fafea1 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -1036,8 +1036,8 @@ static int set_recover_size(struct gfs2_sbd *sdp, struct dlm_slot *slots,
 
 	new_size = old_size + RECOVER_SIZE_INC;
 
-	submit = kzalloc(new_size * sizeof(uint32_t), GFP_NOFS);
-	result = kzalloc(new_size * sizeof(uint32_t), GFP_NOFS);
+	submit = kcalloc(new_size, sizeof(uint32_t), GFP_NOFS);
+	result = kcalloc(new_size, sizeof(uint32_t), GFP_NOFS);
 	if (!submit || !result) {
 		kfree(submit);
 		kfree(result);
-- 
1.8.3.1

