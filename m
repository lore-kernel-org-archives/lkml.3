Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaI0Ix1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:53:27 -0400
Received: from mout.gmx.net ([212.227.15.19]:49695 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbaI0IxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:53:25 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>
Cc: John Stultz <john.stultz@linaro.org>, Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH 1/1] staging : android : sync : get_unused_fd
Date: Sat, 27 Sep 2014 10:52:37 +0200
Message-Id: <1411807958-1522-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.1.0
X-Provags-ID: V03:K0:cF3CP/qpKWkLw7EPZnUYJj/OtUgWKQvax3+5N5gauoOGXeRcgzT
 f1AjVOKkt67S+atOlXUzeDbTp+HQYqWxtzctrqP2nep5JsN8dMWmiUFuO5g+E9EnMhm+8an
 NnV5Sxs2Ar6bv6aY4zpzFEgtgJD24kevwmFPww8Ic0bCbiBFeVIdRrdweXPEO+Ogk1bN1LV
 1Fi1HOvAC9GDE8WwgD0vw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync.h recommends to use get_unused_fd which does not set
O_CLOEXEC while the rest of the android tree uses
get_unused_fd_flags and sets O_CLOEXEC.

The patch adjust the comment.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/staging/android/sync.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 66b0f43..a21b79f 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -293,7 +293,8 @@ void sync_fence_put(struct sync_fence *fence);
  * @fence:	fence to install
  * @fd:		file descriptor in which to install the fence
  *
- * Installs @fence into @fd.  @fd's should be acquired through get_unused_fd().
+ * Installs @fence into @fd.  @fd's should be acquired through
+ * get_unused_fd_flags(O_CLOEXEC).
  */
 void sync_fence_install(struct sync_fence *fence, int fd);
 
-- 
2.1.0

