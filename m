Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaHDROY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:14:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56474 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sage Weil" <sage@newdream.net>,
        "Xi Wang" <xi.wang@gmail.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.925942078@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 88/94] ceph: fix overflow check in build_snap_context()
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit 80834312a4da1405a9bc788313c67643de6fcb4c upstream.

The overflow check for a + n * b should be (n > (ULONG_MAX - a) / b),
rather than (n > ULONG_MAX / b - a).

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Sage Weil <sage@newdream.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ceph/snap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index a559c80..f04c096 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -331,7 +331,7 @@ static int build_snap_context(struct ceph_snap_realm *realm)
 
 	/* alloc new snap context */
 	err = -ENOMEM;
-	if (num > ULONG_MAX / sizeof(u64) - sizeof(*snapc))
+	if (num > (ULONG_MAX - sizeof(*snapc)) / sizeof(u64))
 		goto fail;
 	snapc = kzalloc(sizeof(*snapc) + num*sizeof(u64), GFP_NOFS);
 	if (!snapc)

