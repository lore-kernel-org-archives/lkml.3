Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaHDRLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:11:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56504 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbaHDQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Christoph Hellwig" <hch@lst.de>,
        "Dave Chinner" <dchinner@redhat.com>, "Ben Myers" <bpm@sgi.com>,
        "Chris J Arges" <chris.j.arges@canonical.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.61097646@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 68/94] xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 76d095388b040229ea1aad7dea45be0cfa20f589 upstream.

When we fail to find an matching extent near the requested extent
specification during a left-right distance search in
xfs_alloc_ag_vextent_near, we fail to free the original cursor that
we used to look up the XFS_BTNUM_CNT tree and hence leak it.

Reported-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/xfs/xfs_alloc.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1081,6 +1081,7 @@ restart:
 			goto restart;
 		}
 
+		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 		trace_xfs_alloc_size_neither(args);
 		args->agbno = NULLAGBLOCK;
 		return 0;

