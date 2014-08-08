Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbaHHUxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:53:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41230 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbaHHUxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 208/259] qlcnic: info leak in qlcnic_dcb_peer_app_info()
Date: Fri,  8 Aug 2014 13:40:31 -0700
Message-Id: <1407530482-4483-209-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7df566bbdd0af0785542b89466a937e94257fcfb ]

This function is called from dcbnl_build_peer_app().  The "info"
struct isn't initialized at all so we disclose 2 bytes of uninitialized
stack data.  We should clear it before passing it to the user.

Fixes: 48365e485275 ('qlcnic: dcb: Add support for CEE Netlink interface.')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
index 86bca7c..ca38cb3 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
@@ -1047,6 +1047,7 @@ static int qlcnic_dcb_peer_app_info(struct net_device *netdev,
 	struct qlcnic_dcb_cee *peer;
 	int i;
 
+	memset(info, 0, sizeof(*info));
 	*app_count = 0;
 
 	if (!test_bit(QLCNIC_DCB_STATE, &adapter->dcb->state))
-- 
1.9.1

