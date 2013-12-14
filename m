Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab3LNMc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:32:26 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61492 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3LNMcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:32:25 -0500
Date: Sat, 14 Dec 2013 18:02:16 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH v2 9/9] drivers: net: Mark function xenvif_count_frag_slots()
 as static in netback.c
Message-ID: <609db9fcc843525f9ca2f18673744cad2fb9fb8c.1386911124.git.rashika.kheria@gmail.com>
References: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function xenvif_count_frag_slots() in netback.c as
static because they are not used outside this file.

Thus, it also removes the following warning in xen-netback/netback.c:
drivers/net/xen-netback/netback.c:218:14: warning: no previous prototype for ‘xenvif_count_frag_slots’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---

This revision fixes the following issues of the previous revision:
Change commit message subject

 drivers/net/xen-netback/netback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 64f0e0d..9e4f399 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -215,7 +215,7 @@ struct xenvif_count_slot_state {
 	bool head;
 };
 
-unsigned int xenvif_count_frag_slots(struct xenvif *vif,
+static unsigned int xenvif_count_frag_slots(struct xenvif *vif,
 				     unsigned long offset, unsigned long size,
 				     struct xenvif_count_slot_state *state)
 {
-- 
1.7.9.5

