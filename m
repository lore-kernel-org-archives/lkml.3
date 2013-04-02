Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646Ab3DBWef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:34:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521Ab3DBWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:13:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=DFmann?= <LW@KARO-electronics.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 120/124] net: ethernet: cpsw: fix erroneous condition in error check
Date: Tue,  2 Apr 2013 15:11:42 -0700
Message-Id: <20130402221118.095379465@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>

[ Upstream commit ce16294fda230c787ce5c35f61b2f80d14d70a72 ]

The error check in cpsw_probe_dt() has an '&&' where an '||' is
meant to be. This causes a NULL pointer dereference when incomplet DT
data is passed to the driver ('phy_id' property for cpsw_emac1
missing).

Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1111,7 +1111,7 @@ static int cpsw_probe_dt(struct cpsw_pla
 		struct platform_device *mdio;
 
 		parp = of_get_property(slave_node, "phy_id", &lenp);
-		if ((parp == NULL) && (lenp != (sizeof(void *) * 2))) {
+		if ((parp == NULL) || (lenp != (sizeof(void *) * 2))) {
 			pr_err("Missing slave[%d] phy_id property\n", i);
 			ret = -EINVAL;
 			goto error_ret;


