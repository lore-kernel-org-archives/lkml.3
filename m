Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab3APNI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:08:57 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:62470 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3APNIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:08:55 -0500
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, gregkh@linuxfoundation.org, volokh84@gmail.com,
        dhowells@redhat.com, rdunlap@xenotime.net, hans.verkuil@cisco.com,
        justinmattock@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: media: go7007: call_all stream stuff Some Additional stuff for v4l2_subdev stream events partial need for new style framework. Also need for wis_tw2804 notification stuff
Date: Wed, 16 Jan 2013 17:00:51 +0400
Message-Id: <1358341251-10087-4-git-send-email-volokh84@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
References: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index a69250f..2330861 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -953,6 +953,7 @@ static int vidioc_streamon(struct file *file, void *priv,
 	}
 	mutex_unlock(&go->hw_lock);
 	mutex_unlock(&gofh->lock);
+	call_all(&go->v4l2_dev, video, s_stream, 1);
 
 	return retval;
 }
@@ -968,6 +969,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	mutex_lock(&gofh->lock);
 	go7007_streamoff(go);
 	mutex_unlock(&gofh->lock);
+	call_all(&go->v4l2_dev, video, s_stream, 0);
 
 	return 0;
 }
-- 
1.7.7.6

