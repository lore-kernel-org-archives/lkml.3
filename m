Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab3CZXhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:37:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3CZWoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Torsten Duwe <duwe@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 49/98] KMS: fix EDID detailed timing frame rate
Date: Tue, 26 Mar 2013 15:42:38 -0700
Message-Id: <20130326224247.657013298@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -975,6 +975,7 @@ set_size:
 	}
 
 	mode->type = DRM_MODE_TYPE_DRIVER;
+	mode->vrefresh = drm_mode_vrefresh(mode);
 	drm_mode_set_name(mode);
 
 	return mode;


