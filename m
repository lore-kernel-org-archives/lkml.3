Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3I2Th3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:37:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab3I2T3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [ 55/71] drm/radeon/dpm/rs780: dont enable sclk scaling if not required
Date: Sun, 29 Sep 2013 12:28:07 -0700
Message-Id: <20130929192647.302582873@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e40210cca98068835acd5a4fe760bf96b3a1aa48 upstream.

If the low and high sclks are the same, there is no need to
enable sclk scaling.  This causes display stability issues on
certain boards.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60857

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/rs780_dpm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/rs780_dpm.c
+++ b/drivers/gpu/drm/radeon/rs780_dpm.c
@@ -486,6 +486,9 @@ static void rs780_activate_engine_clk_sc
 	    (new_state->sclk_low == old_state->sclk_low))
 		return;
 
+	if (new_state->sclk_high == new_state->sclk_low)
+		return;
+
 	rs780_clk_scaling_enable(rdev, true);
 }
 


