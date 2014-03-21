Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965415AbaCUAEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:04:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965252AbaCUAEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 109/149] drm/radeon/si: fix typo in dpm sq ramping setup
Date: Thu, 20 Mar 2014 17:04:32 -0700
Message-Id: <20140321000440.740074028@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5b43c3cd07981619dbdb1fb935ef705a3e80955f upstream.

inverted logic.

Noticed-by: Sylvain BERTRAND <sylware@legeek.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si_dpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -2396,7 +2396,7 @@ static int si_populate_sq_ramping_values
 	if (SISLANDS_DPM2_SQ_RAMP_STI_SIZE > (STI_SIZE_MASK >> STI_SIZE_SHIFT))
 		enable_sq_ramping = false;
 
-	if (SISLANDS_DPM2_SQ_RAMP_LTI_RATIO <= (LTI_RATIO_MASK >> LTI_RATIO_SHIFT))
+	if (SISLANDS_DPM2_SQ_RAMP_LTI_RATIO > (LTI_RATIO_MASK >> LTI_RATIO_SHIFT))
 		enable_sq_ramping = false;
 
 	for (i = 0; i < state->performance_level_count; i++) {


