Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaCRFEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 01:04:09 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:39618 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaCRFEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 01:04:08 -0400
Message-ID: <5327D3C6.70400@gmail.com>
Date: Mon, 17 Mar 2014 23:04:06 -0600
From: Joel Pelaez Jorge <joelpelaez@gmail.com>
Organization: DarkSoft Foundation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jingoo Han <jg1.han@samsung.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] staging: slicoss: Fix prefer ether_addr_copy over memcpy
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl issues caused by the new 
function: ether_addr_copy

Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
---
  drivers/staging/slicoss/slicoss.c |   20 ++++++++++----------
  1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c 
b/drivers/staging/slicoss/slicoss.c
index 12aafe3..0e0e374 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -581,15 +581,15 @@ static void slic_adapter_set_hwaddr(struct adapter 
*adapter)
  	struct sliccard *card = adapter->card;

  	if ((adapter->card) && (card->config_set)) {
-		memcpy(adapter->macaddr,
-		       card->config.MacInfo[adapter->functionnumber].macaddrA,
-		       sizeof(struct slic_config_mac));
+		ether_addr_copy(adapter->macaddr,
+				card->config.MacInfo[adapter->functionnumber]
+				.macaddrA);
  		if (is_zero_ether_addr(adapter->currmacaddr))
-			memcpy(adapter->currmacaddr, adapter->macaddr,
-			       ETH_ALEN);
+			ether_addr_copy(adapter->currmacaddr,
+					adapter->macaddr);
  		if (adapter->netdev)
-			memcpy(adapter->netdev->dev_addr, adapter->currmacaddr,
-			       ETH_ALEN);
+			ether_addr_copy(adapter->netdev->dev_addr,
+					adapter->currmacaddr);
  	}
  }

@@ -810,8 +810,8 @@ static int slic_mac_set_address(struct net_device 
*dev, void *ptr)
  	if (!is_valid_ether_addr(addr->sa_data))
  		return -EINVAL;

-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
-	memcpy(adapter->currmacaddr, addr->sa_data, dev->addr_len);
+	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	ether_addr_copy(adapter->currmacaddr, addr->sa_data);

  	slic_config_set(adapter, true);
  	return 0;
@@ -2313,7 +2313,7 @@ static int slic_mcast_add_list(struct adapter 
*adapter, char *address)
  	if (mcaddr == NULL)
  		return 1;

-	memcpy(mcaddr->address, address, ETH_ALEN);
+	ether_addr_copy(mcaddr->address, address);

  	mcaddr->next = adapter->mcastaddrs;
  	adapter->mcastaddrs = mcaddr;
-- 
1.7.10.4

