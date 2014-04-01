Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaDAJQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaDAJQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:52 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 27/29] GFS2: Fix return value in slot_get()
Date: Tue,  1 Apr 2014 10:15:39 +0100
Message-Id: <1396343741-1524-28-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhi Das <adas@redhat.com>

ENOSPC was being returned in slot_get inspite of successful
execution of the function. This patch fixes this return
code.

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 27f9435..c4effff 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -332,6 +332,7 @@ static int slot_get(struct gfs2_quota_data *qd)
 	if (bit < sdp->sd_quota_slots) {
 		set_bit(bit, sdp->sd_quota_bitmap);
 		qd->qd_slot = bit;
+		error = 0;
 out:
 		qd->qd_slot_count++;
 	}
-- 
1.8.3.1

