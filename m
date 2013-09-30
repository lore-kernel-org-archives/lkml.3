Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3I3KUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:20:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab3I3KNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 079/104] v4l2: added missing mutex.h include to v4l2-ctrls.h
Date: Mon, 30 Sep 2013 11:10:56 +0100
Message-Id: <1380535881-9239-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/media/v4l2-ctrls.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 776605f..9b08010 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -22,6 +22,7 @@
 #define _V4L2_CTRLS_H
 
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/videodev2.h>
 
 /* forward references */
-- 
1.8.3.2

