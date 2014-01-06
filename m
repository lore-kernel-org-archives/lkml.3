Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaAFPVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:21:48 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37982 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaAFPVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:21:46 -0500
Date: Mon, 6 Jan 2014 20:51:40 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 22/85] drivers: gpu: Mark functions as static in
 radeon_device.c
Message-ID: <8af55c93ab10b11d473f9c731eddd6710ae7a418.1389018324.git.rashika.kheria@gmail.com>
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

Mark functions radeon_doorbell_init() and radeon_doorbell_fini() as
static in drm/radeon/radeon_device.c because they are not used outside
this file.

This eliminates the following warning in drm/radeon/radeon_device.c:
drivers/gpu/drm/radeon/radeon_device.c:252:5: warning: no previous prototype for ‘radeon_doorbell_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_device.c:281:6: warning: no previous prototype for ‘radeon_doorbell_fini’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 39b033b..caf4975 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -249,7 +249,7 @@ void radeon_scratch_free(struct radeon_device *rdev, uint32_t reg)
  * Init doorbell driver information (CIK)
  * Returns 0 on success, error on failure.
  */
-int radeon_doorbell_init(struct radeon_device *rdev)
+static int radeon_doorbell_init(struct radeon_device *rdev)
 {
 	/* doorbell bar mapping */
 	rdev->doorbell.base = pci_resource_start(rdev->pdev, 2);
@@ -278,7 +278,7 @@ int radeon_doorbell_init(struct radeon_device *rdev)
  *
  * Tear down doorbell driver information (CIK)
  */
-void radeon_doorbell_fini(struct radeon_device *rdev)
+static void radeon_doorbell_fini(struct radeon_device *rdev)
 {
 	iounmap(rdev->doorbell.ptr);
 	rdev->doorbell.ptr = NULL;
-- 
1.7.9.5

