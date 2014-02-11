Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaBKTtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:49:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaBKTH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 075/107] drm/radeon: add UVD support for OLAND
Date: Tue, 11 Feb 2014 11:05:41 -0800
Message-Id: <20140211184750.338515311@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5d029339bb8ce69aeb68280c3de67d3cea456146 upstream.

It seems this got dropped when we merged UVD support
last year.  Add this back now.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_uvd.c |    1 +
 drivers/gpu/drm/radeon/uvd_v2_2.c   |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -91,6 +91,7 @@ int radeon_uvd_init(struct radeon_device
 	case CHIP_VERDE:
 	case CHIP_PITCAIRN:
 	case CHIP_ARUBA:
+	case CHIP_OLAND:
 		fw_name = FIRMWARE_TAHITI;
 		break;
 
--- a/drivers/gpu/drm/radeon/uvd_v2_2.c
+++ b/drivers/gpu/drm/radeon/uvd_v2_2.c
@@ -153,6 +153,7 @@ int uvd_v2_2_resume(struct radeon_device
 		chip_id = 0x01000015;
 		break;
 	case CHIP_PITCAIRN:
+	case CHIP_OLAND:
 		chip_id = 0x01000016;
 		break;
 	case CHIP_ARUBA:


