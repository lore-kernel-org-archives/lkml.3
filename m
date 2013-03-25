Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab3CYBhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:37:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33838 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755577Ab3CYBPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:17 -0400
Message-Id: <20130325010534.518165721@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:07:07 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Torsten Duwe <torsten@lst.de>,
        Torsten Duwe <duwe@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 103/104] KMS: fix EDID detailed timing frame rate
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Duwe <torsten@lst.de>

commit c19b3b0f6eed552952845e4ad908dba2113d67b4 upstream.

When KMS has parsed an EDID "detailed timing", it leaves the frame rate
zeroed.  Consecutive (debug-) output of that mode thus yields 0 for
vsync.  This simple fix also speeds up future invocations of
drm_mode_vrefresh().

While it is debatable whether this qualifies as a -stable fix I'd apply
it for consistency's sake; drm_helper_probe_single_connector_modes()
does the same thing already for all probed modes.

Signed-off-by: Torsten Duwe <duwe@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_edid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -933,6 +933,7 @@ set_size:
 	}
 
 	mode->type = DRM_MODE_TYPE_DRIVER;
+	mode->vrefresh = drm_mode_vrefresh(mode);
 	drm_mode_set_name(mode);
 
 	return mode;


