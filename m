Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3LSMAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:00:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45359 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3LSL77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Chris Mason <clm@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 192/208] Btrfs: fix access_ok() check in btrfs_ioctl_send()
Date: Thu, 19 Dec 2013 11:54:50 +0000
Message-Id: <1387454106-19326-193-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 700ff4f095d78af0998953e922e041d75254518b upstream.

The closing parenthesis is in the wrong place.  We want to check
"sizeof(*arg->clone_sources) * arg->clone_sources_count" instead of
"sizeof(*arg->clone_sources * arg->clone_sources_count)".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/send.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 0c87c6b..d4c34c8 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4613,8 +4613,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	}
 
 	if (!access_ok(VERIFY_READ, arg->clone_sources,
-			sizeof(*arg->clone_sources *
-			arg->clone_sources_count))) {
+			sizeof(*arg->clone_sources) *
+			arg->clone_sources_count)) {
 		ret = -EFAULT;
 		goto out;
 	}
-- 
1.8.3.2

