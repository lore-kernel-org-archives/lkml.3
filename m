Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab3HGSrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:47:43 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:64226 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755416Ab3HGSrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:47:41 -0400
Message-ID: <1375901258.7303.64.camel@x61.thuisdomein>
Subject: [PATCH] IB/qib: make qib_driver static
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Marciniszyn <infinipath@intel.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Aug 2013 20:47:38 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2013 18:47:39.0418 (UTC) FILETIME=[97615FA0:01CE939E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct pci_driver qib_driver is only used in qib_init.c. Remove it from
qib.h and make it static for qib_init.c.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only.

 drivers/infiniband/hw/qib/qib.h      | 1 -
 drivers/infiniband/hw/qib/qib_init.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 4a9af79..1dd4b7c 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -89,7 +89,6 @@ struct qlogic_ib_stats {
 
 extern struct qlogic_ib_stats qib_stats;
 extern const struct pci_error_handlers qib_pci_err_handler;
-extern struct pci_driver qib_driver;
 
 #define QIB_CHIP_SWVERSION QIB_CHIP_VERS_MAJ
 /*
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 36e048e..24e802f 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1193,7 +1193,7 @@ static DEFINE_PCI_DEVICE_TABLE(qib_pci_tbl) = {
 
 MODULE_DEVICE_TABLE(pci, qib_pci_tbl);
 
-struct pci_driver qib_driver = {
+static struct pci_driver qib_driver = {
 	.name = QIB_DRV_NAME,
 	.probe = qib_init_one,
 	.remove = qib_remove_one,
-- 
1.8.1.4

