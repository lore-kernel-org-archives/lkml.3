Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaCRBcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 21:32:21 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:33753 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbaCRBcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 21:32:20 -0400
Message-ID: <5327A222.3020704@gmail.com>
Date: Mon, 17 Mar 2014 19:32:18 -0600
From: =?ISO-8859-1?Q?Joel_Pel=E1ez_Jorge?= <joelpelaez@gmail.com>
Organization: DarkSoft Foundation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
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
diff --git a/drivers/staging/slicoss/slicoss.c 
b/drivers/staging/slicoss/slicoss.c
index 12aafe3..4ff39aa 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2313,7 +2313,7 @@ static int slic_mcast_add_list(struct adapter 
*adapter, char *address)
      if (mcaddr == NULL)
          return 1;

-    memcpy(mcaddr->address, address, ETH_ALEN);
+    ether_addr_copy(mcaddr->address, address);

      mcaddr->next = adapter->mcastaddrs;
      adapter->mcastaddrs = mcaddr;
