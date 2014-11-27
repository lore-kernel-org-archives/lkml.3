Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaK0ReN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:34:13 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:52190 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaK0ReK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:34:10 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v10 05/20] vfio: amba: add the VFIO for AMBA devices module to Kconfig
Date: Thu, 27 Nov 2014 18:32:45 +0100
Message-Id: <1417109580-10505-6-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable building the VFIO AMBA driver. VFIO_AMBA depends on VFIO_PLATFORM,
since it is sharing a portion of the code, and it is essentially implemented
as a platform device whose resources are discovered via AMBA specific APIs
in the kernel.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/Kconfig  | 10 ++++++++++
 drivers/vfio/platform/Makefile |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index c51af17..c0a3bff 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -7,3 +7,13 @@ config VFIO_PLATFORM
 	  framework.
 
 	  If you don't know what to do here, say N.
+
+config VFIO_AMBA
+	tristate "VFIO support for AMBA devices"
+	depends on VFIO_PLATFORM && ARM_AMBA
+	help
+	  Support for ARM AMBA devices with VFIO. This is required to make
+	  use of ARM AMBA devices present on the system using the VFIO
+	  framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
index 279862b..1957170 100644
--- a/drivers/vfio/platform/Makefile
+++ b/drivers/vfio/platform/Makefile
@@ -2,3 +2,7 @@
 vfio-platform-y := vfio_platform.o vfio_platform_common.o
 
 obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
+
+vfio-amba-y := vfio_amba.o
+
+obj-$(CONFIG_VFIO_AMBA) += vfio-amba.o
-- 
2.1.3

