Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaLNWFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:05:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:46067 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaLNWEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:04:34 -0500
Date: Mon, 15 Dec 2014 00:04:28 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 3/6] tools/virtio: 64 bit features
Message-ID: <1418594542-22623-4-git-send-email-mst@redhat.com>
References: <1418594542-22623-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418594542-22623-1-git-send-email-mst@redhat.com>
X-Mailer: git-send-email 2.0.0.545.gd9cabeb
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missed one place where vringh_test used
long to pass features. Fix it up to u64.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/virtio/vringh_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index 13e0a76..51d922f 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -132,7 +132,7 @@ static inline int vringh_get_head(struct vringh *vrh, u16 *head)
 	return 1;
 }
 
-static int parallel_test(unsigned long features,
+static int parallel_test(u64 features,
 			 bool (*getrange)(struct vringh *vrh,
 					  u64 addr, struct vringh_range *r),
 			 bool fast_vringh)
-- 
MST

