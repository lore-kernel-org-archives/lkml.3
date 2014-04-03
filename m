Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaDCTuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:50:21 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:48098 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaDCTuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:50:15 -0400
From: =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>
To: tj@kernel.org
Cc: d@falconindy.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        P@draigbrady.com, alexandre.f.demers@gmail.com,
        =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>,
        "3.14" <stable@vger.kernel.org>
Subject: [PATCH] fs: Don't return 0 from get_anon_bdev
Date: Thu,  3 Apr 2014 21:49:55 +0200
Message-Id: <1396554595-11796-1-git-send-email-thomas@archlinux.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140403191617.GB2472@mtj.dyndns.org>
References: <20140403191617.GB2472@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9e30cc9595303b27b48 removed an internal mount. This
has the side-effect that rootfs now has FSID 0. Many
userspace utilities assume that st_dev in struct stat
is never 0, so this change breaks a number of tools in
early userspace.

Since we don't know how many userspace programs are affected,
make sure that FSID is at least 1.

References: http://article.gmane.org/gmane.linux.kernel/1666905
References: http://permalink.gmane.org/gmane.linux.utilities.util-linux-ng/8557
Cc: 3.14 <stable@vger.kernel.org>
Signed-off-by: Thomas Bächler <thomas@archlinux.org>
---
 fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 80d5cf2..d9fddde 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -802,7 +802,7 @@ void emergency_remount(void)
 
 static DEFINE_IDA(unnamed_dev_ida);
 static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
-static int unnamed_dev_start = 0; /* don't bother trying below it */
+static int unnamed_dev_start = 1; /* don't bother trying below it */
 
 int get_anon_bdev(dev_t *p)
 {
-- 
1.9.1

