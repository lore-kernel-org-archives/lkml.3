Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3FDOIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:08:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46942 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab3FDOIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 62/70] xen-netback: fix sparse warning
Date: Tue,  4 Jun 2013 15:07:18 +0100
Message-Id: <1370354846-14213-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

commit 9eaee8beeeb3bca0d9b14324fd9d467d48db784c upstream.

Fix warning about 0 used as NULL.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netback/netback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 1e343b7..c2a3786 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1521,7 +1521,7 @@ static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx,
 
 	xenvif_put(vif);
 
-	netbk->mmap_pages[pending_idx]->mapping = 0;
+	netbk->mmap_pages[pending_idx]->mapping = NULL;
 	put_page(netbk->mmap_pages[pending_idx]);
 	netbk->mmap_pages[pending_idx] = NULL;
 }
-- 
1.8.1.2

