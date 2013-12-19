Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3LSPFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:05:16 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40344 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab3LSPFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:05:10 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        xen-devel@lists.xenproject.org
Subject: [PATCH 26/38] xen: xenbus: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:37 +0100
Message-Id: <1387465429-3568-27-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/xen/xenbus/xenbus_probe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 3c0a74b..4abb9ee 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -465,8 +465,10 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 
 	/* Register with generic device framework. */
 	err = device_register(&xendev->dev);
-	if (err)
+	if (err) {
+		put_device(&xendev->dev);
 		goto fail;
+	}
 
 	return 0;
 fail:
-- 
1.8.3.1

