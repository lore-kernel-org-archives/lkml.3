Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbbAYSLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:11:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbbAYSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 19/98] drm/radeon: work around a hw bug in MGCG on CIK
Date: Sun, 25 Jan 2015 10:06:37 -0800
Message-Id: <20150125180713.710887431@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4bb62c95a7e781a238b2ab374f34b1bf91e01ddc upstream.

Always need to set bit 0 of RLC_CGTT_MGCG_OVERRIDE
to avoid unreliable doorbell updates in some cases.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -5879,6 +5879,7 @@ static void cik_enable_mgcg(struct radeo
 		}
 
 		orig = data = RREG32(RLC_CGTT_MGCG_OVERRIDE);
+		data |= 0x00000001;
 		data &= 0xfffffffd;
 		if (orig != data)
 			WREG32(RLC_CGTT_MGCG_OVERRIDE, data);
@@ -5910,7 +5911,7 @@ static void cik_enable_mgcg(struct radeo
 		}
 	} else {
 		orig = data = RREG32(RLC_CGTT_MGCG_OVERRIDE);
-		data |= 0x00000002;
+		data |= 0x00000003;
 		if (orig != data)
 			WREG32(RLC_CGTT_MGCG_OVERRIDE, data);
 


