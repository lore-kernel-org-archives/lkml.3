Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966193AbaCUBA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:00:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965440AbaCUAEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 107/149] drm/radeon/cik: properly set compute ring status on disable
Date: Thu, 20 Mar 2014 17:04:30 -0700
Message-Id: <20140321000440.669385974@linuxfoundation.org>
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

commit b2b3d8d952e4f8d6ac2ce80be96b937f29f6e42e upstream.

When we disable the rings, set the status properly.  If
not other code pathes may try and use the rings which are
not functional at this point.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -4069,8 +4069,11 @@ static void cik_cp_compute_enable(struct
 {
 	if (enable)
 		WREG32(CP_MEC_CNTL, 0);
-	else
+	else {
 		WREG32(CP_MEC_CNTL, (MEC_ME1_HALT | MEC_ME2_HALT));
+		rdev->ring[CAYMAN_RING_TYPE_CP1_INDEX].ready = false;
+		rdev->ring[CAYMAN_RING_TYPE_CP2_INDEX].ready = false;
+	}
 	udelay(50);
 }
 


