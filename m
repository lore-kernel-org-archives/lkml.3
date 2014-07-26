Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaGZTfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:35:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaGZTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shirley Ma <shirley.ma@oracle.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 032/109] net/mlx4_core: Fix the error flow when probing with invalid VF configuration
Date: Sat, 26 Jul 2014 12:01:54 -0700
Message-Id: <20140726190224.793536415@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

[ Upstream commit 960b1f454e1ace6b76718f22828bcc3594a09422 ]

Single ported VF are currently not supported on configurations where
one or both ports are IB. When we hit this case, the relevant flow in
the driver didn't return error and jumped to the wrong label. Fix that.

Fixes: dd41cc3 ('net/mlx4: Adapt num_vfs/probed_vf params for single port VF')
Reported-by: Shirley Ma <shirley.ma@oracle.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2466,7 +2466,8 @@ slave_start:
 					 "with IB port. Single port VFs syntax"
 					 " is only supported when all ports "
 					 "are configured as ethernet\n");
-				goto err_close;
+				err = -EINVAL;
+				goto err_master_mfunc;
 			}
 			for (i = 0; i < sizeof(nvfs)/sizeof(nvfs[0]); i++) {
 				unsigned j;


