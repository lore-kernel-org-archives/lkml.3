Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab3EQVs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:48:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab3EQVsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:48:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Dave Airlie <airlied@redhat.com>
Subject: [ 49/50] drm/radeon: check incoming cliprects pointer
Date: Fri, 17 May 2013 14:47:24 -0700
Message-Id: <20130517213847.806800365@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit fefaedcfb82d2e57c2320acf60604ab03b750cc0 upstream.

The "boxes" parameter points into userspace memory. It should be verified
like any other operation against user memory.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


