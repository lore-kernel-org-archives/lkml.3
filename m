Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbaJCWCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:02:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaJCVxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Chernovskiy <algonkvel@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 058/238] drm/radeon: Add missing lines to ci_set_thermal_temperature_range
Date: Fri,  3 Oct 2014 14:29:33 -0700
Message-Id: <20141003212915.528981305@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Chernovskiy <algonkvel@gmail.com>

commit 6bce8d9772c1c606921a9c99e566eb14202f6669 upstream.

Properly set the thermal min and max temp on CI.
Otherwise, we end up setting the thermal ranges
to 0 on resume and end up in the lowest power state.

Signed-off-by: Oleg Chernovskiy <algonkvel@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ci_dpm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -851,6 +851,9 @@ static int ci_set_thermal_temperature_ra
 	WREG32_SMC(CG_THERMAL_CTRL, tmp);
 #endif
 
+	rdev->pm.dpm.thermal.min_temp = low_temp;
+	rdev->pm.dpm.thermal.max_temp = high_temp;
+
 	return 0;
 }
 


