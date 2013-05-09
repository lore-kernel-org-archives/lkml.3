Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab3EIWxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:53:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800Ab3EIWdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 48/73] drm/radeon: fix typo in rv515_mc_resume()
Date: Thu,  9 May 2013 15:32:11 -0700
Message-Id: <20130509222803.182490970@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 367cbe2fec9b57b72605e2ac4cfd4f2fa823a256 upstream.

Doesn't affect anything as the same address gets written
in both cases.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/rv515.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -348,7 +348,7 @@ void rv515_mc_resume(struct radeon_devic
 	/* update crtc base addresses */
 	for (i = 0; i < rdev->num_crtc; i++) {
 		if (rdev->family >= CHIP_RV770) {
-			if (i == 1) {
+			if (i == 0) {
 				WREG32(R700_D1GRPH_PRIMARY_SURFACE_ADDRESS_HIGH,
 				       upper_32_bits(rdev->mc.vram_start));
 				WREG32(R700_D1GRPH_SECONDARY_SURFACE_ADDRESS_HIGH,


