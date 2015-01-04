Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbbADU6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 15:58:16 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:49550 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbbADU5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 15:57:17 -0500
From: David Decotigny <ddecotig@gmail.com>
To: Amir Vadai <amirv@mellanox.com>, Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: David Decotigny <decot@googlers.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Ben Hutchings <ben@decadent.org.uk>,
        Masatake YAMATO <yamato@redhat.com>, Xi Wang <xii@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        Tom Gundersen <teg@jklm.no>, Jiri Pirko <jiri@resnulli.us>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@Emulex.Com>,
        Govindarajulu Varadarajan <_govind@gmx.com>
Subject: [PATCH net-next v1 5/7] net: veth: extend link mode support to 48 bits
Date: Sun,  4 Jan 2015 12:56:55 -0800
Message-Id: <1420405017-23278-6-git-send-email-ddecotig@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1420405017-23278-1-git-send-email-ddecotig@gmail.com>
References: <1420405017-23278-1-git-send-email-ddecotig@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>

Signed-off-by: David Decotigny <decot@googlers.com>
---
 drivers/net/veth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 8ad5965..902e127 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -49,8 +49,8 @@ static struct {
 
 static int veth_get_settings(struct net_device *dev, struct ethtool_cmd *cmd)
 {
-	cmd->supported		= 0;
-	cmd->advertising	= 0;
+	ethtool_cmd_supported_set(cmd, 0);
+	ethtool_cmd_advertising_set(cmd, 0);
 	ethtool_cmd_speed_set(cmd, SPEED_10000);
 	cmd->duplex		= DUPLEX_FULL;
 	cmd->port		= PORT_TP;
-- 
2.2.0.rc0.207.ga3a616c

