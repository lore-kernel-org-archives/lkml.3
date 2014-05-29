Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbaE2FGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:06:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbaE2Ef5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eyal Perry <eyalpe@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 108/140] net/mlx4_core: Dont issue PCIe speed/width checks for VFs
Date: Wed, 28 May 2014 21:34:07 -0700
Message-Id: <20140529043103.463288884@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Perry <eyalpe@mellanox.com>

[ Upstream commit 83d3459a5928f18c9344683e31bc2a7c3c25562a ]

Carrying out PCI speed/width checks through pcie_get_minimum_link()
on VFs yield wrong results, so remove them.

Fixes: b912b2f ('net/mlx4_core: Warn if device doesn't have enough PCI bandwidth')
Signed-off-by: Eyal Perry <eyalpe@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2399,7 +2399,8 @@ slave_start:
 	 * No return code for this call, just warn the user in case of PCI
 	 * express device capabilities are under-satisfied by the bus.
 	 */
-	mlx4_check_pcie_caps(dev);
+	if (!mlx4_is_slave(dev))
+		mlx4_check_pcie_caps(dev);
 
 	/* In master functions, the communication channel must be initialized
 	 * after obtaining its address from fw */


