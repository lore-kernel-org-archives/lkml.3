Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934372AbaE2FYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:24:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbaE2EfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 059/140] drm/radeon: clear needs_reset flag if IB test fails
Date: Wed, 28 May 2014 21:33:18 -0700
Message-Id: <20140529043057.063137026@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 06a139f7a0885fa2c84962300edd181821ddc2c9 upstream.

If the IB test fails we don't want to reset the card over
and over again, just accept that it isn't working.

Bug: https://bugs.freedesktop.org/show_bug.cgi?id=76501

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_ring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -257,6 +257,7 @@ int radeon_ib_ring_tests(struct radeon_d
 		r = radeon_ib_test(rdev, i, ring);
 		if (r) {
 			ring->ready = false;
+			rdev->needs_reset = false;
 
 			if (i == RADEON_RING_TYPE_GFX_INDEX) {
 				/* oh, oh, that's really bad */


