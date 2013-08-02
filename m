Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573Ab3HBKMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:12:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030524Ab3HBKMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:12:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [ 85/99] drm/radeon: fix audio dto programming on DCE4+
Date: Fri,  2 Aug 2013 18:08:38 +0800
Message-Id: <20130802100237.761122634@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7d61d835824f73dc4097b51f800382467c8049c5 upstream.

We need to set the dto source before setting the
dividers otherwise we may get stability problems
with the dto leading to audio playback problems.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -157,9 +157,9 @@ static void evergreen_audio_set_dto(stru
 	 * number (coefficient of two integer numbers.  DCCG_AUDIO_DTOx_PHASE
 	 * is the numerator, DCCG_AUDIO_DTOx_MODULE is the denominator
 	 */
+	WREG32(DCCG_AUDIO_DTO_SOURCE, DCCG_AUDIO_DTO0_SOURCE_SEL(radeon_crtc->crtc_id));
 	WREG32(DCCG_AUDIO_DTO0_PHASE, base_rate * 100);
 	WREG32(DCCG_AUDIO_DTO0_MODULE, clock * 100);
-	WREG32(DCCG_AUDIO_DTO_SOURCE, DCCG_AUDIO_DTO0_SOURCE_SEL(radeon_crtc->crtc_id));
 }
 
 


