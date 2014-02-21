Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaBUDOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 22:14:51 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:44897
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbaBUDOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 22:14:49 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI specified resources
Date: Thu, 20 Feb 2014 20:06:18 -0800
Message-Id: <1392955578-8411-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in the resource walking code. This patch depends on
commit number: 90f3453585479d5beb75058da46eb573ced0e6ac

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/vmbus_drv.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index b37c91b..2352ae48 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -899,10 +899,12 @@ static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *ctx)
 	switch (res->type) {
 	case ACPI_RESOURCE_TYPE_IRQ:
 		irq = res->data.irq.interrupts[0];
+		break;
 
 	case ACPI_RESOURCE_TYPE_ADDRESS64:
 		hyperv_mmio_start = res->data.address64.minimum;
 		hyperv_mmio_size = res->data.address64.address_length;
+		break;
 	}
 
 	return AE_OK;
-- 
1.7.4.1

