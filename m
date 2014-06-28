Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaF1Rr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:47:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaF1RrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.4 39/43] fs: btrfs: volumes.c: Fix for possible null pointer dereference
Date: Sat, 28 Jun 2014 10:46:30 -0700
Message-Id: <20140628174451.572596316@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

commit 8321cf2596d283821acc466377c2b85bcd3422b7 upstream.

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1446,11 +1446,12 @@ int btrfs_rm_device(struct btrfs_root *r
 		struct btrfs_fs_devices *fs_devices;
 		fs_devices = root->fs_info->fs_devices;
 		while (fs_devices) {
-			if (fs_devices->seed == cur_devices)
+			if (fs_devices->seed == cur_devices) {
+				fs_devices->seed = cur_devices->seed;
 				break;
+			}
 			fs_devices = fs_devices->seed;
 		}
-		fs_devices->seed = cur_devices->seed;
 		cur_devices->seed = NULL;
 		lock_chunks(root);
 		__btrfs_close_devices(cur_devices);


