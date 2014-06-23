Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaFWIk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:40:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55566 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 093/111] qlcnic: info leak in qlcnic_dcb_peer_app_info()
Date: Mon, 23 Jun 2014 10:32:08 +0200
Message-Id: <d8981d30858dafaf3b603ffd2d1231f410821e29.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 7df566bbdd0af0785542b89466a937e94257fcfb ]

This function is called from dcbnl_build_peer_app().  The "info"
struct isn't initialized at all so we disclose 2 bytes of uninitialized
stack data.  We should clear it before passing it to the user.

Fixes: 48365e485275 ('qlcnic: dcb: Add support for CEE Netlink interface.')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
index d62d5ce432ec..d677eabf3c1e 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
@@ -1053,6 +1053,7 @@ static int qlcnic_dcb_peer_app_info(struct net_device *netdev,
 	struct qlcnic_dcb_cee *peer;
 	int i;
 
+	memset(info, 0, sizeof(*info));
 	*app_count = 0;
 
 	if (!test_bit(__QLCNIC_DCB_STATE, &adapter->state))
-- 
2.0.0

