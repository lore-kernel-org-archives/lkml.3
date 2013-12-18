Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3LRV2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:28:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab3LRVNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jie Liu <jeff.liu@oracle.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.12 078/118] Btrfs: fix access_ok() check in btrfs_ioctl_send()
Date: Wed, 18 Dec 2013 13:11:55 -0800
Message-Id: <20131218211221.656116738@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 700ff4f095d78af0998953e922e041d75254518b upstream.

The closing parenthesis is in the wrong place.  We want to check
"sizeof(*arg->clone_sources) * arg->clone_sources_count" instead of
"sizeof(*arg->clone_sources * arg->clone_sources_count)".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4756,8 +4756,8 @@ long btrfs_ioctl_send(struct file *mnt_f
 	}
 
 	if (!access_ok(VERIFY_READ, arg->clone_sources,
-			sizeof(*arg->clone_sources *
-			arg->clone_sources_count))) {
+			sizeof(*arg->clone_sources) *
+			arg->clone_sources_count)) {
 		ret = -EFAULT;
 		goto out;
 	}


