Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbaBKUq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:46:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaBKTFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 081/120] drm/radeon/runpm: dont runtime suspend non-PX cards
Date: Tue, 11 Feb 2014 11:05:22 -0800
Message-Id: <20140211184825.926760817@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9babd35ad72af631547c7ca294bc2e931cc40e58 upstream.

Prevent runtime suspend of non-PX GPUs.  Runtime suspend is
not what we want in those cases.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_drv.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -400,6 +400,9 @@ static int radeon_pmops_runtime_suspend(
 	if (radeon_runtime_pm == 0)
 		return -EINVAL;
 
+	if (radeon_runtime_pm == -1 && !radeon_is_px())
+		return -EINVAL;
+
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
 	drm_kms_helper_poll_disable(drm_dev);
 	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_OFF);
@@ -422,6 +425,9 @@ static int radeon_pmops_runtime_resume(s
 	if (radeon_runtime_pm == 0)
 		return -EINVAL;
 
+	if (radeon_runtime_pm == -1 && !radeon_is_px())
+		return -EINVAL;
+
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
 
 	pci_set_power_state(pdev, PCI_D0);


