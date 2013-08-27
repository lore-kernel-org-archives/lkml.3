Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3H0BHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3H0BHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 49/74] drm/radeon/r7xx: fix copy paste typo in golden register setup
Date: Mon, 26 Aug 2013 18:08:47 -0700
Message-Id: <20130827010434.729003305@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 022374c02e357ac82e98dd2689fb2efe05723d69 upstream.

Uses the wrong array size for some asics which can lead
to garbage getting written to registers.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60674

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/rv770.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -744,10 +744,10 @@ static void rv770_init_golden_registers(
 						 (const u32)ARRAY_SIZE(r7xx_golden_dyn_gpr_registers));
 		radeon_program_register_sequence(rdev,
 						 rv730_golden_registers,
-						 (const u32)ARRAY_SIZE(rv770_golden_registers));
+						 (const u32)ARRAY_SIZE(rv730_golden_registers));
 		radeon_program_register_sequence(rdev,
 						 rv730_mgcg_init,
-						 (const u32)ARRAY_SIZE(rv770_mgcg_init));
+						 (const u32)ARRAY_SIZE(rv730_mgcg_init));
 		break;
 	case CHIP_RV710:
 		radeon_program_register_sequence(rdev,
@@ -758,18 +758,18 @@ static void rv770_init_golden_registers(
 						 (const u32)ARRAY_SIZE(r7xx_golden_dyn_gpr_registers));
 		radeon_program_register_sequence(rdev,
 						 rv710_golden_registers,
-						 (const u32)ARRAY_SIZE(rv770_golden_registers));
+						 (const u32)ARRAY_SIZE(rv710_golden_registers));
 		radeon_program_register_sequence(rdev,
 						 rv710_mgcg_init,
-						 (const u32)ARRAY_SIZE(rv770_mgcg_init));
+						 (const u32)ARRAY_SIZE(rv710_mgcg_init));
 		break;
 	case CHIP_RV740:
 		radeon_program_register_sequence(rdev,
 						 rv740_golden_registers,
-						 (const u32)ARRAY_SIZE(rv770_golden_registers));
+						 (const u32)ARRAY_SIZE(rv740_golden_registers));
 		radeon_program_register_sequence(rdev,
 						 rv740_mgcg_init,
-						 (const u32)ARRAY_SIZE(rv770_mgcg_init));
+						 (const u32)ARRAY_SIZE(rv740_mgcg_init));
 		break;
 	default:
 		break;


