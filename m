Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaGHAac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:30:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbaGGXyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.14 77/94] mlx4_core: Fix incorrect FLAGS1 bitmap test in mlx4_QUERY_FUNC_CAP
Date: Mon,  7 Jul 2014 16:58:07 -0700
Message-Id: <20140707235759.049193697@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit bc82878baa10c2a6a4a6affaf52c152935112142 upstream.

Commit eb17711bc1d6 ("net/mlx4_core: Introduce nic_info new flag in
QUERY_FUNC_CAP") did:

	if (func_cap->flags1 & QUERY_FUNC_CAP_FLAGS1_OFFSET) {

which should be:

	if (func_cap->flags1 & QUERY_FUNC_CAP_FLAGS1_FORCE_VLAN) {

Fix that.

Fixes: eb17711bc1d6 ("net/mlx4_core: Introduce nic_info new flag in QUERY_FUNC_CAP")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -398,7 +398,7 @@ int mlx4_QUERY_FUNC_CAP(struct mlx4_dev
 
 	MLX4_GET(func_cap->flags1, outbox, QUERY_FUNC_CAP_FLAGS1_OFFSET);
 	if (dev->caps.port_type[gen_or_port] == MLX4_PORT_TYPE_ETH) {
-		if (func_cap->flags1 & QUERY_FUNC_CAP_FLAGS1_OFFSET) {
+		if (func_cap->flags1 & QUERY_FUNC_CAP_FLAGS1_FORCE_VLAN) {
 			mlx4_err(dev, "VLAN is enforced on this port\n");
 			err = -EPROTONOSUPPORT;
 			goto out;


