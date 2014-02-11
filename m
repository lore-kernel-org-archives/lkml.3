Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaBKTwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:52:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbaBKTHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 072/107] drm/radeon: disable ss on DP for DCE3.x
Date: Tue, 11 Feb 2014 11:05:38 -0800
Message-Id: <20140211184750.247331311@linuxfoundation.org>
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

commit d8e24525094200601236fa64a54cf73e3d682f2e upstream.

Seems to cause problems with certain DP monitors.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=40699

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -938,11 +938,14 @@ static bool atombios_crtc_prepare_pll(st
 							radeon_atombios_get_ppll_ss_info(rdev,
 											 &radeon_crtc->ss,
 											 ATOM_DP_SS_ID1);
-				} else
+				} else {
 					radeon_crtc->ss_enabled =
 						radeon_atombios_get_ppll_ss_info(rdev,
 										 &radeon_crtc->ss,
 										 ATOM_DP_SS_ID1);
+				}
+				/* disable spread spectrum on DCE3 DP */
+				radeon_crtc->ss_enabled = false;
 			}
 			break;
 		case ATOM_ENCODER_MODE_LVDS:


