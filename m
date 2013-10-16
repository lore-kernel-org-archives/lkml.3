Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761877Ab3JPRzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:55:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761301Ab3JPRq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 29/50] drm/radeon: forever loop on error in radeon_do_test_moves()
Date: Wed, 16 Oct 2013 10:45:15 -0700
Message-Id: <20131016174401.868104051@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 89cd67b326fa95872cc2b4524cd807128db6071d upstream.

The error path does this:

	for (--i; i >= 0; --i) {

which is a forever loop because "i" is unsigned.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_test.c
+++ b/drivers/gpu/drm/radeon/radeon_test.c
@@ -36,8 +36,8 @@ static void radeon_do_test_moves(struct
 	struct radeon_bo *vram_obj = NULL;
 	struct radeon_bo **gtt_obj = NULL;
 	uint64_t gtt_addr, vram_addr;
-	unsigned i, n, size;
-	int r, ring;
+	unsigned n, size;
+	int i, r, ring;
 
 	switch (flag) {
 	case RADEON_TEST_COPY_DMA:


