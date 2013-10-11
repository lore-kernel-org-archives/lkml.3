Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3JKG2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:28:07 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:52970 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab3JKG1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:27:30 -0400
From: Kim Phillips <kim.phillips@linaro.org>
To: Bhushan Bharat <R65777@freescale.com>, Wood Scott <B07421@freescale.com>,
        Yoder Stuart <B08248@freescale.com>, christoffer.dall@linaro.org,
        alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        a.motakis@virtualopensystems.com, agraf@suse.de,
        Sethi Varun <B16395@freescale.com>, peter.maydell@linaro.org,
        santosh.shukla@linaro.org, kvm@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via sysfs only
Date: Fri, 11 Oct 2013 01:27:19 -0500
Message-Id: <1381472840-3470-3-git-send-email-kim.phillips@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
References: <1381418830.7979.405.camel@snotra.buserror.net>
 <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Force the vfio-pci driver to only be bound explicitly via sysfs to avoid
conflics with other drivers in the event of a hotplug.

Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
---
 drivers/vfio/pci/vfio_pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6ab71b9..bdd7833 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -901,6 +901,9 @@ static struct pci_driver vfio_pci_driver = {
 	.probe		= vfio_pci_probe,
 	.remove		= vfio_pci_remove,
 	.err_handler	= &vfio_err_handlers,
+	.driver = {
+		.sysfs_bind_only = true,
+	},
 };
 
 static void __exit vfio_pci_cleanup(void)
-- 
1.8.4

