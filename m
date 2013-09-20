Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab3ITUPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:15:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3ITUPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:15:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 65/93] [media] v4l2: added missing mutex.h include to v4l2-ctrls.h
Date: Fri, 20 Sep 2013 13:09:00 -0700
Message-Id: <1379707768-1804-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Hajda <a.hajda@samsung.com>

commit a19dec6ea94c036af68c31930c1c92681f55af41 upstream.

This patch fixes following error:
include/media/v4l2-ctrls.h:193:15: error: field ‘_lock’ has incomplete type
include/media/v4l2-ctrls.h: In function ‘v4l2_ctrl_lock’:
include/media/v4l2-ctrls.h:570:2: error: implicit declaration of
	function ‘mutex_lock’ [-Werror=implicit-function-declaration]
include/media/v4l2-ctrls.h: In function ‘v4l2_ctrl_unlock’:
include/media/v4l2-ctrls.h:579:2: error: implicit declaration of
	function ‘mutex_unlock’ [-Werror=implicit-function-declaration]

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/media/v4l2-ctrls.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 9650911..0f9b3c3 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -22,6 +22,7 @@
 #define _V4L2_CTRLS_H
 
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/videodev2.h>
 
 /* forward references */
-- 
1.8.1.2

