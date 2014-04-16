Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbaDPJls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:41:48 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42460 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaDPJlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:41:09 -0400
Date: Wed, 16 Apr 2014 18:40:40 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: plagnioj@jcrosoft.com
Cc: tomi.valkeinen@ti.com, jg1.han@samsung.com,
        laurent.pinchart@ideasonboard.com, daeseok.youn@gmail.com,
        robdclark@gmail.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fbdev: fix possible NULL pointer derefernce
Message-ID: <20140416094034.GA18082@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spec->modedb can be NULL by fb_create_modedb().

And also smatch says:
drivers/video/fbdev/core/fbmon.c:975 fb_edid_to_monspecs() error:
potential null dereference 'specs->modedb'.
(fb_create_modedb returns null)

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/video/fbdev/core/fbmon.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/fbdev/core/fbmon.c b/drivers/video/fbdev/core/fbmon.c
index c204ebe..db274ca 100644
--- a/drivers/video/fbdev/core/fbmon.c
+++ b/drivers/video/fbdev/core/fbmon.c
@@ -966,6 +966,9 @@ void fb_edid_to_monspecs(unsigned char *edid, struct fb_monspecs *specs)
 
 	specs->modedb = fb_create_modedb(edid, &specs->modedb_len);
 
+	if (!specs->modedb)
+		return;
+
 	/*
 	 * Workaround for buggy EDIDs that sets that the first
 	 * detailed timing is preferred but has not detailed
-- 
1.7.4.4

