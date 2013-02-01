Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422828Ab3BANNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:13:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:45452 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964774Ab3BANNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:13:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 69/89] drm/radeon: fix error path in kpage allocation
Date: Fri,  1 Feb 2013 14:08:24 +0100
Message-Id: <20130201130212.451859557@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ihadzic@research.bell-labs.com>

commit 25d8999780f8c1f53928f4a24a09c01550423109 upstream.

Index into chunks[] array doesn't look right.

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_cs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -271,8 +271,8 @@ int radeon_cs_parser_init(struct radeon_
 			p->chunks[p->chunk_ib_idx].kpage[1] = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			if (p->chunks[p->chunk_ib_idx].kpage[0] == NULL ||
 			    p->chunks[p->chunk_ib_idx].kpage[1] == NULL) {
-				kfree(p->chunks[i].kpage[0]);
-				kfree(p->chunks[i].kpage[1]);
+				kfree(p->chunks[p->chunk_ib_idx].kpage[0]);
+				kfree(p->chunks[p->chunk_ib_idx].kpage[1]);
 				return -ENOMEM;
 			}
 		}


