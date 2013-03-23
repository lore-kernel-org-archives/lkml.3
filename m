Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3CWOpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 10:45:54 -0400
Received: from verein.lst.de ([213.95.11.211]:42299 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab3CWOpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 10:45:51 -0400
Date: Sat, 23 Mar 2013 15:39:34 +0100 (MET)
From: Torsten Duwe <torsten@lst.de>
To: David Airlie <airlied@linux.ie>, torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KMS: fix EDID detailed timing frame rate
In-Reply-To: <alpine.LNX.2.02.1303231531520.2097@blackhole.lst.de>
Message-ID: <alpine.LNX.2.02.1303231538310.2097@blackhole.lst.de>
References: <alpine.LNX.2.02.1303231531520.2097@blackhole.lst.de>
User-Agent: Alpine 2.02 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When KMS has parsed an EDID "detailed timing", it leaves the frame
rate zeroed. Consecutive (debug-) output of that mode thus yields 0
for vsync. This simple fix also speeds up future invocations of
drm_mode_vrefresh(). While it is debatable whether this qualifies
as a -stable fix I'd apply it for consistency's sake;
drm_helper_probe_single_connector_modes() does the same thing already
for all probed modes.

Cc: stable@vger.kernel.org
Signed-off-by: Torsten Duwe <duwe@lst.de>

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -977,6 +977,7 @@ set_size:
 	}
 
 	mode->type = DRM_MODE_TYPE_DRIVER;
+	mode->vrefresh = drm_mode_vrefresh(mode);
 	drm_mode_set_name(mode);
 
 	return mode;

