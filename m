Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaAFPpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:45:34 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58284 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaAFPpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:45:33 -0500
Date: Mon, 6 Jan 2014 21:15:28 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 38/85] drivers: gpu: Move prototype declaration to header
 file radeon.h from radeon_acpi.c
Message-ID: <0a42faede948b6c7053cfa1523e5e7f2fcf633fb.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declarations of functions radeon_pm_acpi_event_handler()
to header file drm/radeon/radeon.h because it is used by more than one
file.

This eliminates the following warning in drm/radeon/radeon_pm.c:
drivers/gpu/drm/radeon/radeon_pm.c:68:6: warning: no previous prototype for ‘radeon_pm_acpi_event_handler’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon.h      |    1 +
 drivers/gpu/drm/radeon/radeon_acpi.c |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 28414f2..8e0b9dd 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -104,6 +104,7 @@ u32 r600_gpu_check_soft_reset(struct radeon_device *rdev);
 
 void r600_ih_ring_fini(struct radeon_device *rdev);
 int r600_ih_ring_alloc(struct radeon_device *rdev);
+void radeon_pm_acpi_event_handler(struct radeon_device *rdev);
 
 /*
  * Copy from radeon_drv.h so we don't have to include both and have conflicting
diff --git a/drivers/gpu/drm/radeon/radeon_acpi.c b/drivers/gpu/drm/radeon/radeon_acpi.c
index 98a9074..d3018cb 100644
--- a/drivers/gpu/drm/radeon/radeon_acpi.c
+++ b/drivers/gpu/drm/radeon/radeon_acpi.c
@@ -39,8 +39,6 @@
 
 #define ACPI_AC_CLASS           "ac_adapter"
 
-extern void radeon_pm_acpi_event_handler(struct radeon_device *rdev);
-
 struct atif_verify_interface {
 	u16 size;		/* structure size in bytes (includes size field) */
 	u16 version;		/* version */
-- 
1.7.9.5

