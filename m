Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464Ab3DKUc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:32:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31361 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758624Ab3DKU0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:15 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=AUdBAo876HwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=QguDOkfF5moA:10 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=74J67IGakc5LYT1cVsQA:9 a=oUQuMaGMe1cA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202553.365379721@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Torsten Duwe <duwe@lst.de>
Subject: [ 044/171 ] KMS: fix EDID detailed timing frame rate
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0044-KMS-fix-EDID-detailed-timing-frame-rate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Torsten Duwe <torsten@lst.de>

[ Upstream commit c19b3b0f6eed552952845e4ad908dba2113d67b4 ]

When KMS has parsed an EDID "detailed timing", it leaves the frame rate
zeroed.  Consecutive (debug-) output of that mode thus yields 0 for
vsync.  This simple fix also speeds up future invocations of
drm_mode_vrefresh().

While it is debatable whether this qualifies as a -stable fix I'd apply
it for consistency's sake; drm_helper_probe_single_connector_modes()
does the same thing already for all probed modes.

Cc: stable@vger.kernel.org
Signed-off-by: Torsten Duwe <duwe@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/drm_edid.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index fafd5a1..24763fa 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -960,6 +960,7 @@ set_size:
 	}
 
 	mode->type = DRM_MODE_TYPE_DRIVER;
+	mode->vrefresh = drm_mode_vrefresh(mode);
 	drm_mode_set_name(mode);
 
 	return mode;
-- 
1.7.10.4


