Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945949Ab3BHBST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:18:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab3BHA5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 03/34] drm/radeon/evergreen+: wait for the MC to settle after MC blackout
Date: Thu,  7 Feb 2013 16:56:59 -0800
Message-Id: <20130208004627.939261062@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ed39fadd6df01095378e499fac3674883f16b853 upstream.

Some chips seem to need a little delay after blacking out
the MC before the requests actually stop.

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=56139
https://bugs.freedesktop.org/show_bug.cgi?id=57567

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1345,6 +1345,8 @@ void evergreen_mc_stop(struct radeon_dev
 		blackout &= ~BLACKOUT_MODE_MASK;
 		WREG32(MC_SHARED_BLACKOUT_CNTL, blackout | 1);
 	}
+	/* wait for the MC to settle */
+	udelay(100);
 }
 
 void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save)


