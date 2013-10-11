Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab3JKTsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:48:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759085Ab3JKTmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 126/135] Btrfs: reset ret in record_one_backref
Date: Fri, 11 Oct 2013 12:40:07 -0700
Message-Id: <20131011193958.949925440@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 50f1319cb5f7690e4d9de18d1a75ea89296d0e53 upstream.

I was getting warnings when running find ./ -type f -exec btrfs fi defrag -f {}
\; from record_one_backref because ret was set.  Turns out it was because it was
set to 1 because the search slot didn't come out exact and we never reset it.
So reset it to 0 right after the search so we don't leak this and get
uneccessary warnings.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2132,6 +2132,7 @@ static noinline int record_one_backref(u
 		WARN_ON(1);
 		return ret;
 	}
+	ret = 0;
 
 	while (1) {
 		cond_resched();
@@ -2181,8 +2182,6 @@ static noinline int record_one_backref(u
 		    old->len || extent_offset + num_bytes <=
 		    old->extent_offset + old->offset)
 			continue;
-
-		ret = 0;
 		break;
 	}
 


