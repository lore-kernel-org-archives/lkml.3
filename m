Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3H0BJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:09:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3H0BHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 50/74] drm/radeon: fix UVD message buffer validation
Date: Mon, 26 Aug 2013 18:08:48 -0700
Message-Id: <20130827010434.877723106@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 112a6d0c071808f6d48354fc8834a574e5dcefc0 upstream.

When the message buffer is currently moving block until it is idle again.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_uvd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -359,6 +359,14 @@ static int radeon_uvd_cs_msg(struct rade
 		return -EINVAL;
 	}
 
+	if (bo->tbo.sync_obj) {
+		r = radeon_fence_wait(bo->tbo.sync_obj, false);
+		if (r) {
+			DRM_ERROR("Failed waiting for UVD message (%d)!\n", r);
+			return r;
+		}
+	}
+
 	r = radeon_bo_kmap(bo, &ptr);
 	if (r)
 		return r;


