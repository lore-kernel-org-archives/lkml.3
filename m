Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaBKUsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:48:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaBKTFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 076/120] drm/radeon: disable dpm on BTC
Date: Tue, 11 Feb 2014 11:05:17 -0800
Message-Id: <20140211184825.779058410@linuxfoundation.org>
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

commit 919cf555c04e16dafb1fba56904eb23889a812c3 upstream.

Still unstable on some boards.

Bugs:
https://bugs.freedesktop.org/show_bug.cgi?id=73053
https://bugzilla.kernel.org/show_bug.cgi?id=68571

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_pm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1230,6 +1230,9 @@ int radeon_pm_init(struct radeon_device
 	case CHIP_RV670:
 	case CHIP_RS780:
 	case CHIP_RS880:
+	case CHIP_BARTS:
+	case CHIP_TURKS:
+	case CHIP_CAICOS:
 	case CHIP_CAYMAN:
 	case CHIP_BONAIRE:
 	case CHIP_KABINI:
@@ -1259,9 +1262,6 @@ int radeon_pm_init(struct radeon_device
 	case CHIP_PALM:
 	case CHIP_SUMO:
 	case CHIP_SUMO2:
-	case CHIP_BARTS:
-	case CHIP_TURKS:
-	case CHIP_CAICOS:
 	case CHIP_ARUBA:
 	case CHIP_TAHITI:
 	case CHIP_PITCAIRN:


