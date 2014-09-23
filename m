Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaIWOsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:48:00 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58637 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaIWOr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:47:57 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, kvm@vger.kernel.org,
        christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, eric.auger@linaro.org,
        marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv7 13/26] vfio: amba: add the VFIO for AMBA devices module to Kconfig
Date: Tue, 23 Sep 2014 16:46:12 +0200
Message-Id: <1411483586-29304-14-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
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
index c51af17..8b97786 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -7,3 +7,13 @@ config VFIO_PLATFORM
 	  framework.
 
 	  If you don't know what to do here, say N.
+
+config VFIO_AMBA
+	tristate "VFIO support for AMBA devices"
+	depends on VFIO && VFIO_PLATFORM && EVENTFD && ARM_AMBA
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
1.8.3.2

