Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbaF1Sdz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:33:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaF1Rum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.14 101/110] Btrfs: use right type to get real comparison
Date: Sat, 28 Jun 2014 10:47:38 -0700
Message-Id: <20140628174551.425334649@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit cd857dd6bc2ae9ecea14e75a34e8a8fdc158e307 upstream.

We want to make sure the point is still within the extent item, not to verify
the memory it's pointing to.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/backref.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1431,7 +1431,7 @@ static int __get_extent_inline_ref(unsig
 			*out_eiref = (struct btrfs_extent_inline_ref *)(ei + 1);
 		}
 		*ptr = (unsigned long)*out_eiref;
-		if ((void *)*ptr >= (void *)ei + item_size)
+		if ((unsigned long)(*ptr) >= (unsigned long)ei + item_size)
 			return -ENOENT;
 	}
 


