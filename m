Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaIKMpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:45:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51646 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755434AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.237556331@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 043/131] netlabel: use GFP flags from caller instead
 of GFP_ATOMIC
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 64b5fad526f63e9b56752a7e8e153b99ec0ddecd upstream.

This function takes a GFP flags as a parameter, but they are never used.
We don't take a lock in this function so there is no reason to prefer
GFP_ATOMIC over the caller's GFP flags.

There is only one caller, cipso_v4_map_cat_rng_ntoh(), and it passes
GFP_ATOMIC as the GFP flags so this doesn't change how the code works.
It's just a cleanup.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netlabel/netlabel_kapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -597,7 +597,7 @@ int netlbl_secattr_catmap_setrng(struct
 			iter = iter->next;
 			iter_max_spot = iter->startbit + NETLBL_CATMAP_SIZE;
 		}
-		ret_val = netlbl_secattr_catmap_setbit(iter, spot, GFP_ATOMIC);
+		ret_val = netlbl_secattr_catmap_setbit(iter, spot, flags);
 	}
 
 	return ret_val;

