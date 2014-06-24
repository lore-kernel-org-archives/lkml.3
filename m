Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbaFXPxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:53:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaFXPxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:53:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 13/68] qlcnic: info leak in qlcnic_dcb_peer_app_info()
Date: Tue, 24 Jun 2014 11:50:32 -0400
Message-Id: <20140624154724.516793835@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7df566bbdd0af0785542b89466a937e94257fcfb ]

This function is called from dcbnl_build_peer_app().  The "info"
struct isn't initialized at all so we disclose 2 bytes of uninitialized
stack data.  We should clear it before passing it to the user.

Fixes: 48365e485275 ('qlcnic: dcb: Add support for CEE Netlink interface.')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
@@ -1022,6 +1022,7 @@ static int qlcnic_dcb_peer_app_info(stru
 	struct qlcnic_dcb_cee *peer;
 	int i;
 
+	memset(info, 0, sizeof(*info));
 	*app_count = 0;
 
 	if (!test_bit(QLCNIC_DCB_STATE, &adapter->dcb->state))


