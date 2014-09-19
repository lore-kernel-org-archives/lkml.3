Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbaISWiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:38:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:43763 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848AbaISWiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:38:18 -0400
Message-ID: <541CB055.6000504@infradead.org>
Date: Fri, 19 Sep 2014 15:38:13 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
CC: LKML <linux-kernel@vger.kernel.org>, Anish Bhatt <anish@chelsio.com>,
        James Bottomley <jbottomley@parallels.com>
Subject: [PATCH] scsi: fix SCSI_BNX2X_FCOE dependencies and build errors
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Don't enable NETDEVICES when NET is not enabled. That causes
build warnings and errors.

warning: (SCSI_CXGB3_ISCSI && SCSI_CXGB4_ISCSI && SCSI_BNX2X_FCOE) selects NETDEVICES which has unmet direct dependencies (NET)
warning: (SCSI_CXGB3_ISCSI && SCSI_CXGB4_ISCSI && SCSI_BNX2_ISCSI && SCSI_BNX2X_FCOE) selects ETHERNET which has unmet direct dependencies (NETDEVICES && NET)
warning: (SCSI_BNX2X_FCOE && LIBFCOE && TCM_QLA2XXX) selects LIBFC which has unmet direct dependencies (SCSI_LOWLEVEL && SCSI && SCSI_FC_ATTRS)

../drivers/net/ethernet/cisco/enic/enic_main.c: In function 'enic_rq_indicate_buf':
../drivers/net/ethernet/cisco/enic/enic_main.c:1077:3: error: implicit declaration of function 'skb_mark_napi_id' [-Werror=implicit-function-declaration]
../drivers/net/ethernet/cisco/enic/enic_main.c:1078:3: error: implicit declaration of function 'enic_poll_busy_polling' [-Werror=implicit-function-declaration]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/scsi/bnx2fc/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20140918.orig/drivers/scsi/bnx2fc/Kconfig
+++ linux-next-20140918/drivers/scsi/bnx2fc/Kconfig
@@ -1,7 +1,8 @@
 config SCSI_BNX2X_FCOE
 	tristate "QLogic NetXtreme II FCoE support"
-	depends on PCI
+	depends on PCI && NET
 	depends on (IPV6 || IPV6=n)
+	depends on SCSI_FC_ATTRS
 	select NETDEVICES
 	select ETHERNET
 	select NET_VENDOR_BROADCOM
