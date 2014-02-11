Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbaBKUo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:44:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBKTFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 084/120] drm/radeon/DCE4+: clear bios scratch dpms bit (v2)
Date: Tue, 11 Feb 2014 11:05:25 -0800
Message-Id: <20140211184826.008794328@linuxfoundation.org>
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

commit 6802d4bad83f50081b2788698570218aaff8d10e upstream.

The BlankCrtc table in some DCE8 boards has some
logic shortcuts for the vbios when this bit is set.
Clear it for driver use.

v2: fix typo

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=73420

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -3944,6 +3944,10 @@ void radeon_atom_initialize_bios_scratch
 	/* tell the bios not to handle mode switching */
 	bios_6_scratch |= ATOM_S6_ACC_BLOCK_DISPLAY_SWITCH;
 
+	/* clear the vbios dpms state */
+	if (ASIC_IS_DCE4(rdev))
+		bios_2_scratch &= ~ATOM_S2_DEVICE_DPMS_STATE;
+
 	if (rdev->family >= CHIP_R600) {
 		WREG32(R600_BIOS_2_SCRATCH, bios_2_scratch);
 		WREG32(R600_BIOS_6_SCRATCH, bios_6_scratch);


