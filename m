Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaCZPlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:41:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15807 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaCZPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:41:22 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-83-5332f521efa7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>, Rob Herring <robh@kernel.org>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ata: sata_highbank: remove superfluous cast
Date: Wed, 26 Mar 2014 16:41 +0100
Message-id: <11638294.fp3ZK6zVlg@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jQV3Fr0bBBpe+6llsenyN1eLYjkdM
	Fpd3zWGzuN52it3i/54d7Ba/lh9ldGDzWPD5CrvHplWdbB6bl9R7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWxY+sGpoKd7BUfn95ja2BczdbFyMkhIWAicWXOVVYIW0ziwr31QHEuDiGB6YwS60/d
	ZYFwWpgkNrSuYQSpYhOwkpjYvgrMFhGQlbgy7SEjSBGzwEZGiVUn/rOAJIQFbCR2vJ0DNJaD
	g0VASeLziVyQMK+AlkTv1Mlgm0UFPCV2bF/JBhEXlPgx+R5YK7OAvMS+/VNZIWwtifU7jzNN
	YOSbhaRsFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDtBnUjsYVzZYHGIU
	4GBU4uHdcd8oWIg1say4MvcQowQHs5IIr+4zoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63W
	gUIC6YklqdmpqQWpRTBZJg5OqQbG6bfN1QuY2cSz1jcvkChjlfplnR03O2H1+WbVFPFjH1tn
	fV8Ys3bJhPCZgpktMjmFzaUatZwZOaKzmBKlXIxbr8083SEzbVPFwkDbMF/xJ9ZRtTIZqUni
	j/XnFB8Tadn349hR8ZacTWEBG5mC9r2/bfZndXlCSUfe/bNf3+zImVV0oflLn7sSS3FGoqEW
	c1FxIgB+9jwJTAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpriv->plat_data is 'void *' so there is no need to cast it to
'struct ecx_plat_data *'.

Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/sata_highbank.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/sata_highbank.c
===================================================================
--- a/drivers/ata/sata_highbank.c	2014-03-14 16:45:04.384724376 +0100
+++ b/drivers/ata/sata_highbank.c	2014-03-26 16:28:40.927062349 +0100
@@ -141,7 +141,7 @@ static ssize_t ecx_transmit_led_message(
 					ssize_t size)
 {
 	struct ahci_host_priv *hpriv =  ap->host->private_data;
-	struct ecx_plat_data *pdata = (struct ecx_plat_data *) hpriv->plat_data;
+	struct ecx_plat_data *pdata = hpriv->plat_data;
 	struct ahci_port_priv *pp = ap->private_data;
 	unsigned long flags;
 	int pmp, i;

