Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3AYVw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 16:52:29 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:57656 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753019Ab3AYVw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 16:52:28 -0500
Message-ID: <5102FE97.20508@semaphore.gr>
Date: Fri, 25 Jan 2013 23:52:23 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
CC: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: infiniband: Fix compiler warning
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compiler warning of uninitialized variable

drivers/infiniband/hw/mlx4/qp.c: In function ‘mlx4_ib_post_send’:
drivers/infiniband/hw/mlx4/qp.c:1862:62: warning: ‘vlan’ may be used uninitialized
in this function [-Wmaybe-uninitialized]
drivers/infiniband/hw/mlx4/qp.c:1752:6: note: ‘vlan’ was declared here

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/infiniband/hw/mlx4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 19e0637..37829b6 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1749,7 +1749,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
        int is_eth;
        int is_vlan = 0;
        int is_grh;
-       u16 vlan;
+       u16 vlan = 0;
        int err = 0;

        send_size = 0;
-- 
1.8.1

