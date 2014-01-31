Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaAaCRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 21:17:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068AbaAaCRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 21:17:40 -0500
Date: Thu, 30 Jan 2014 21:17:30 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: alexander.deucher@amd.com
Subject: drm/radeon/dpm: fix uninitialized read from stack in
 kv_dpm_late_enable
Message-ID: <20140131021730.GA11601@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	alexander.deucher@amd.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we take the false branch of the if quoted in the diff below, we
end up doing a return ret, without ever having initialized it.

Picked up by coverity.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
 
diff --git a/drivers/gpu/drm/radeon/kv_dpm.c b/drivers/gpu/drm/radeon/kv_dpm.c
index b6e01d5d2cce..351db361239d 100644
--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -1223,7 +1223,7 @@ int kv_dpm_enable(struct radeon_device *rdev)
 
 int kv_dpm_late_enable(struct radeon_device *rdev)
 {
-	int ret;
+	int ret = 0;
 
 	if (rdev->irq.installed &&
 	    r600_is_internal_thermal_sensor(rdev->pm.int_thermal_type)) {
