Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab3APXnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:43:13 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:30115 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab3APXnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:43:12 -0500
Message-ID: <1358379788.7243.10.camel@lorien2>
Subject: [PATCH] drm/radeon: fix NULL pointer dereference in UMS mode in
 radeon_cs_parser_fini()
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: airlied@linux.ie, deathsimple@vodafone.de, jglisse@redhat.com,
        airlied@redhat.com, alexander.deucher@amd.com
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com, Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 16 Jan 2013 16:43:08 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix parser->rdev NULL pointer dereference in radeon_cs_parser_fini().
While back-porting drm/radeon: fix NULL pointer dereference in UMS mode
patch (commit-id: ff4bd0827764e10a428a9d39e6814c5478863f94) to 3,7.y, noticed
another instance of NULL pointer dereference in radeon_cs_parser_fini()
function.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
CC: stable@vger.kernel.org 3.7
---
 drivers/gpu/drm/radeon/radeon_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index 469661f..d1c282c 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -329,7 +329,7 @@ static void radeon_cs_parser_fini(struct radeon_cs_parser *parser, int error)
 	kfree(parser->relocs_ptr);
 	for (i = 0; i < parser->nchunks; i++) {
 		kfree(parser->chunks[i].kdata);
-		if ((parser->rdev->flags & RADEON_IS_AGP)) {
+		if (parser->rdev && (parser->rdev->flags & RADEON_IS_AGP)) {
 			kfree(parser->chunks[i].kpage[0]);
 			kfree(parser->chunks[i].kpage[1]);
 		}
-- 
1.7.9.5



