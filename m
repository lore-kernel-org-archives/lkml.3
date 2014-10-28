Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaJ1DgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:36:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaJ1DgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:36:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.17 011/146] btrfs: Fix the wrong condition judgment about subset extent map
Date: Tue, 28 Oct 2014 11:32:33 +0800
Message-Id: <20141028033343.923305147@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

commit 32be3a1ac6d09576c57063c6c350ca36eaebdbd3 upstream.

Previous commit: btrfs: Fix and enhance merge_extent_mapping() to insert
best fitted extent map
is using wrong condition to judgement whether the range is a subset of a
existing extent map.

This may cause bug in btrfs no-holes mode.

This patch will correct the judgment and fix the bug.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6528,7 +6528,7 @@ insert:
 		 * extent causing the -EEXIST.
 		 */
 		if (start >= extent_map_end(existing) ||
-		    start + len <= existing->start) {
+		    start <= existing->start) {
 			/*
 			 * The existing extent map is the one nearest to
 			 * the [start, start + len) range which overlaps


