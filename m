Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab3LSNJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:09:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3LSLzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 010/208] bonding: don't permit to use ARP monitoring in 802.3ad mode
Date: Thu, 19 Dec 2013 11:51:48 +0000
Message-Id: <1387454106-19326-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

commit ec9f1d15db8185f63a2c3143dc1e90ba18541b08 upstream.

Currently the ARP monitoring is not supported with 802.3ad, and it's
prohibited to use it via the module params.

However we still can set it afterwards via sysfs, cause we only check for
*LB modes there.

To fix this - add a check for 802.3ad mode in bonding_store_arp_interval.

CC: Jay Vosburgh <fubar@us.ibm.com>
CC: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/bonding/bond_sysfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index dc36a3d..076f8af 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -565,8 +565,9 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 		goto out;
 	}
 	if (bond->params.mode == BOND_MODE_ALB ||
-	    bond->params.mode == BOND_MODE_TLB) {
-		pr_info("%s: ARP monitoring cannot be used with ALB/TLB. Only MII monitoring is supported on %s.\n",
+	    bond->params.mode == BOND_MODE_TLB ||
+	    bond->params.mode == BOND_MODE_8023AD) {
+		pr_info("%s: ARP monitoring cannot be used with ALB/TLB/802.3ad. Only MII monitoring is supported on %s.\n",
 			bond->dev->name, bond->dev->name);
 		ret = -EINVAL;
 		goto out;
-- 
1.8.3.2

