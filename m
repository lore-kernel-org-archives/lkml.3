Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab3JKTmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:42:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab3JKTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 112/135] drm/radeon: fix hdmi callbacks for rv6xx (incorrectly added to r520)
Date: Fri, 11 Oct 2013 12:39:53 -0700
Message-Id: <20131011193957.459489113@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

Commit 99d79aa2f3b7729e7290e8bda5d0dd8b0240ec62 was backported slightly
wrong adding callbacks in the wrong struct. This moves callbacks to the
correct place (matching mainline patch/code).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_asic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -926,8 +926,6 @@ static struct radeon_asic r520_asic = {
 		.wait_for_vblank = &avivo_wait_for_vblank,
 		.set_backlight_level = &atombios_set_backlight_level,
 		.get_backlight_level = &atombios_get_backlight_level,
-		.hdmi_enable = &r600_hdmi_enable,
-		.hdmi_setmode = &r600_hdmi_setmode,
 	},
 	.copy = {
 		.blit = &r100_copy_blit,
@@ -1115,6 +1113,8 @@ static struct radeon_asic rv6xx_asic = {
 		.wait_for_vblank = &avivo_wait_for_vblank,
 		.set_backlight_level = &atombios_set_backlight_level,
 		.get_backlight_level = &atombios_get_backlight_level,
+		.hdmi_enable = &r600_hdmi_enable,
+		.hdmi_setmode = &r600_hdmi_setmode,
 	},
 	.copy = {
 		.blit = &r600_copy_blit,


