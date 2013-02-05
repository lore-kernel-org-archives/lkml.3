Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab3BEWLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:11:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694Ab3BEWLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:11:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 55/93] drm/radeon: fix error path in kpage allocation
Date: Tue,  5 Feb 2013 20:06:44 -0200
Message-Id: <1360102042-10732-56-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ihadzic@research.bell-labs.com>

commit 25d8999780f8c1f53928f4a24a09c01550423109 upstream.

Index into chunks[] array doesn't look right.

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_cs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index 66d81ae..c71652b 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -279,8 +279,8 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
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
-- 
1.7.9.5

