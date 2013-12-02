Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab3LBUry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:47:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab3LBTNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 101/173] drm/radeon: dont share PPLLs on DCE4.1
Date: Mon,  2 Dec 2013 11:11:24 -0800
Message-Id: <20131202191155.612898203@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 70471860ff9f335c60c004d42ebd48945bfa5403 upstream.

Sharing PPLLs seems to cause problems on some boards.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=45334

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1683,7 +1683,7 @@ static int radeon_atom_pick_pll(struct d
 				if (pll != ATOM_PPLL_INVALID)
 					return pll;
 			}
-		} else {
+		} else if (!ASIC_IS_DCE41(rdev)) { /* Don't share PLLs on DCE4.1 chips */
 			/* use the same PPLL for all monitors with the same clock */
 			pll = radeon_get_shared_nondp_ppll(crtc);
 			if (pll != ATOM_PPLL_INVALID)


