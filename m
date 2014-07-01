Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbaGATCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:02:11 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:10391 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbaGATCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:02:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0HAMEEs1NbsGsk/2dsb2JhbABagw2sYwUBbpIbh0CBDhd1hAsCUyOBAgcRN4guAxUBswaPSA2GCReFb4cJgUNkHYQtBZd8bIF+i0WCLIYSg0Q7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/1] drm/bochs: replace ALIGN(PAGE_SIZE) by PAGE_ALIGN
Date: Tue,  1 Jul 2014 21:02:03 +0200
Message-Id: <1404241323-15156-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: David Airlie <airlied@linux.ie>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/gpu/drm/bochs/bochs_mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bochs/bochs_mm.c b/drivers/gpu/drm/bochs/bochs_mm.c
index b9a695d..1728a1b 100644
--- a/drivers/gpu/drm/bochs/bochs_mm.c
+++ b/drivers/gpu/drm/bochs/bochs_mm.c
@@ -387,7 +387,7 @@ int bochs_gem_create(struct drm_device *dev, u32 size, bool iskernel,
 
 	*obj = NULL;
 
-	size = ALIGN(size, PAGE_SIZE);
+	size = PAGE_ALIGN(size);
 	if (size == 0)
 		return -EINVAL;
 
-- 
1.9.1

