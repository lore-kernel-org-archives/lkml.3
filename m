Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab3E1Dyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:54:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52575 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758845Ab3E1DyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:10 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kees Cook" <keescook@chromium.org>,
        "Dave Airlie" <airlied@redhat.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.201391471@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [28/94] drm/radeon: check incoming cliprects pointer
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit fefaedcfb82d2e57c2320acf60604ab03b750cc0 upstream.

The "boxes" parameter points into userspace memory. It should be verified
like any other operation against user memory.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/r300_cmdbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/r300_cmdbuf.c
+++ b/drivers/gpu/drm/radeon/r300_cmdbuf.c
@@ -74,7 +74,7 @@ static int r300_emit_cliprects(drm_radeo
 		OUT_RING(CP_PACKET0(R300_RE_CLIPRECT_TL_0, nr * 2 - 1));
 
 		for (i = 0; i < nr; ++i) {
-			if (DRM_COPY_FROM_USER_UNCHECKED
+			if (DRM_COPY_FROM_USER
 			    (&box, &cmdbuf->boxes[n + i], sizeof(box))) {
 				DRM_ERROR("copy cliprect faulted\n");
 				return -EFAULT;

