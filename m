Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaFEEgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:36:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaFEEVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 165/214] drm/radeon: fix typo in evergreen_mc_resume()
Date: Wed,  4 Jun 2014 21:18:48 -0700
Message-Id: <20140605041701.712218286@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 695ddeb457584a602f2ba117d08ce37cf6ec1589 upstream.

Add missing index that may have led us to enabling
more crtcs than necessary.

May also fix:
https://bugs.freedesktop.org/show_bug.cgi?id=56139

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1292,7 +1292,7 @@ void evergreen_mc_resume(struct radeon_d
 	WREG32(BIF_FB_EN, FB_READ_EN | FB_WRITE_EN);
 
 	for (i = 0; i < rdev->num_crtc; i++) {
-		if (save->crtc_enabled) {
+		if (save->crtc_enabled[i]) {
 			if (ASIC_IS_DCE6(rdev)) {
 				tmp = RREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i]);
 				tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;


