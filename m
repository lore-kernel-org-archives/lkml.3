Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323Ab3HICAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:00:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030290Ab3HIB7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 100/102] net/mlx4_core: VFs must ignore the enable_64b_cqe_eqe module param
Date: Thu,  8 Aug 2013 18:58:16 -0700
Message-Id: <20130809015033.861055543@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

[ Upstream commit b30513202c6c14120f70b2e9aa1e97d47bbc2313 ]

Slaves get the 64B CQE/EQE state from QUERY_HCA, not from the module parameter.

If the parameter is set to zero, the slave outputs an incorrect/irrelevant
warning message that 64B CQEs/EQEs are supported but not enabled (even if the
hypervisor has enabled 64B CQEs/EQEs).

Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -371,7 +371,7 @@ static int mlx4_dev_cap(struct mlx4_dev
 
 	dev->caps.sqp_demux = (mlx4_is_master(dev)) ? MLX4_MAX_NUM_SLAVES : 0;
 
-	if (!enable_64b_cqe_eqe) {
+	if (!enable_64b_cqe_eqe && !mlx4_is_slave(dev)) {
 		if (dev_cap->flags &
 		    (MLX4_DEV_CAP_FLAG_64B_CQE | MLX4_DEV_CAP_FLAG_64B_EQE)) {
 			mlx4_warn(dev, "64B EQEs/CQEs supported by the device but not enabled\n");


