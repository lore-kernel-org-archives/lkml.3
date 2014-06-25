Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbaFYSkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:40:51 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:27308 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757657AbaFYSku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:40:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4HAFgXq1NXQ7ge/2dsb2JhbABZgw2rLgsFAZR6hECBDhd1hGAjgRo3iEYBqw+YFxeFY4kZHYQtBZpRizaINYNEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steven Whitehouse <swhiteho@redhat.com>,
        cluster-devel@redhat.com
Subject: [PATCH 1/1] fs/gfs2/lock_dlm.c: replace count*size kzalloc by kcalloc
Date: Wed, 25 Jun 2014 20:40:45 +0200
Message-Id: <1403721645-19455-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/gfs2/lock_dlm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
1.9.1

