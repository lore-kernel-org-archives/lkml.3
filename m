Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaBIO1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 09:27:49 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:37383 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaBIO1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 09:27:47 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=2001/13=5D=20net=3A=20Mark=20function=20as=20static=20in=209p/client=2Ec?=
Date: Sun,  9 Feb 2014 19:57:33 +0530
Message-Id: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in net/9p/client.c because it is not used
outside this file.

This eliminates the following warning in net/9p/client.c:
net/9p/client.c:207:18: warning: no previous prototype for ‘p9_fcall_alloc’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 net/9p/client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index a5e4d2d..9186550 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -204,7 +204,7 @@ free_and_return:
 	return ret;
 }
 
-struct p9_fcall *p9_fcall_alloc(int alloc_msize)
+static struct p9_fcall *p9_fcall_alloc(int alloc_msize)
 {
 	struct p9_fcall *fc;
 	fc = kmalloc(sizeof(struct p9_fcall) + alloc_msize, GFP_NOFS);
-- 
1.7.9.5

