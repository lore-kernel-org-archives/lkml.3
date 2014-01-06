Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaAFWjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:39:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbaAFWi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 071/144] drm/radeon/dpm: disable ss on Cayman
Date: Mon,  6 Jan 2014 14:37:12 -0800
Message-Id: <20140106223747.384032905@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c745fe611ca42295c9d91d8e305d27983e9132ef upstream.

Spread spectrum seems to cause hangs when dynamic clock
switching is enabled.  Disable it for now. This does not
affect performance or the amount of power saved. Tracked
down by Martin Andersson.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=69723

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/rv770_dpm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -2328,6 +2328,12 @@ void rv770_get_engine_memory_ss(struct r
 	pi->mclk_ss = radeon_atombios_get_asic_ss_info(rdev, &ss,
 						       ASIC_INTERNAL_MEMORY_SS, 0);
 
+	/* disable ss, causes hangs on some cayman boards */
+	if (rdev->family == CHIP_CAYMAN) {
+		pi->sclk_ss = false;
+		pi->mclk_ss = false;
+	}
+
 	if (pi->sclk_ss || pi->mclk_ss)
 		pi->dynamic_ss = true;
 	else


