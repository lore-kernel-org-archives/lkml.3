Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3KWMB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 07:01:59 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:51727 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3KWMB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 07:01:57 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] genetlink: Fix uninitialized variable in genl_validate_assign_mc_groups()
Date: Sat, 23 Nov 2013 13:01:50 +0100
Message-Id: <1385208110-17120-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/netlink/genetlink.c: In function ‘genl_validate_assign_mc_groups’:
net/netlink/genetlink.c:217: warning: ‘err’ may be used uninitialized in this
function

Commit 2a94fe48f32ccf7321450a2cc07f2b724a444e5b ("genetlink: make multicast
groups const, prevent abuse") split genl_register_mc_group() in multiple
functions, but dropped the initialization of err.

Initialize err to zero to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Question: Is the for_each_net_rcu() loop in genl_validate_assign_mc_groups()
          guaranteed to loop at least once?
	  If yes, this is a false positive.

 net/netlink/genetlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 4518a57aa5fe..803206e82450 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -214,7 +214,7 @@ static int genl_validate_assign_mc_groups(struct genl_family *family)
 {
 	int first_id;
 	int n_groups = family->n_mcgrps;
-	int err, i;
+	int err = 0, i;
 	bool groups_allocated = false;
 
 	if (!n_groups)
-- 
1.7.9.5

