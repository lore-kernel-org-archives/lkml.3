Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbaISXAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:00:30 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:22642
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932205AbaISXA3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:00:29 -0400
From: Anish Bhatt <anish@chelsio.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
CC: LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: RE: [PATCH] scsi: fix SCSI_BNX2X_FCOE dependencies and build errors
Thread-Topic: [PATCH] scsi: fix SCSI_BNX2X_FCOE dependencies and build errors
Thread-Index: AQHP1Fppssfx2r3GbUujvsveyIG5wJwJES7V
Date: Fri, 19 Sep 2014 22:59:13 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D88EF6BE@nice.asicdesigners.com>
References: <541CB055.6000504@infradead.org>
In-Reply-To: <541CB055.6000504@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.163.152]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leaves only 1 warning still reproduceable : 
(LIBFCOE && TCM_QLA2XXX) selects LIBFC which has unmet direct dependencies (SCSI_LOWLEVEL && SCSI && SCSI_FC_ATTRS),
 so maybe that needs a fix too ? All the other fcoe/scsi menu entries behave 
as expected.

Tested-by: Anish Bhatt <anish@chelsio.com>
________________________________________
From: Randy Dunlap [rdunlap@infradead.org]
Sent: Friday, September 19, 2014 3:38 PM
To: netdev@vger.kernel.org; David Miller
Cc: LKML; Anish Bhatt; James Bottomley
Subject: [PATCH] scsi: fix SCSI_BNX2X_FCOE dependencies and build errors

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
-       depends on PCI
+       depends on PCI && NET
        depends on (IPV6 || IPV6=n)
+       depends on SCSI_FC_ATTRS
        select NETDEVICES
        select ETHERNET
        select NET_VENDOR_BROADCOM
