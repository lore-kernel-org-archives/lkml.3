Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3JKTkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:40:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab3JKTki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 093/110] Revert "drm/radeon: add missing hdmi callbacks for rv6xx"
Date: Fri, 11 Oct 2013 12:39:13 -0700
Message-Id: <20131011193817.949191202@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

This reverts commit b2a9484006875ecd7d94582e7bcb72a02682be92.

Commit 99d79aa2f3b7729e7290e8bda5d0dd8b0240ec62 (backported by
b2a9484006875ecd7d94582e7bcb72a02682be92) was supposed to fix rv6xx_asic
struct.

In kernel 3.10 we didn't have that struct yet, so the original patch
should never be backported to the 3.10. Accidentally it has applied and
modified different struct (r520_asic) that shouldn't have any HDMI
callbacks at all.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_asic.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -892,8 +892,6 @@ static struct radeon_asic r520_asic = {
 		.wait_for_vblank = &avivo_wait_for_vblank,
 		.set_backlight_level = &atombios_set_backlight_level,
 		.get_backlight_level = &atombios_get_backlight_level,
-		.hdmi_enable = &r600_hdmi_enable,
-		.hdmi_setmode = &r600_hdmi_setmode,
 	},
 	.copy = {
 		.blit = &r100_copy_blit,


