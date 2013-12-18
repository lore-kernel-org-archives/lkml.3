Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3LRVOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:14:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab3LRVOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 3.12 108/118] Btrfs: fix memory leak of chunks extent map
Date: Wed, 18 Dec 2013 13:12:25 -0800
Message-Id: <20131218211222.519254593@linuxfoundation.org>
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

From: Liu Bo <bo.li.liu@oracle.com>

commit 7d3d1744f8a7d62e4875bd69cc2192a939813880 upstream.

As we're hold a ref on looking up the extent map, we need to drop the ref
before returning to callers.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4488,6 +4488,7 @@ int btrfs_num_copies(struct btrfs_fs_inf
 		btrfs_crit(fs_info, "Invalid mapping for %Lu-%Lu, got "
 			    "%Lu-%Lu\n", logical, logical+len, em->start,
 			    em->start + em->len);
+		free_extent_map(em);
 		return 1;
 	}
 
@@ -4668,6 +4669,7 @@ static int __btrfs_map_block(struct btrf
 		btrfs_crit(fs_info, "found a bad mapping, wanted %Lu, "
 			   "found %Lu-%Lu\n", logical, em->start,
 			   em->start + em->len);
+		free_extent_map(em);
 		return -EINVAL;
 	}
 


