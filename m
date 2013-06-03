Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab3FCWPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:15:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20804 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759167Ab3FCWMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:46 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Y6dR7-qOpOgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=D32nsUY9JpIA:10 a=cm27Pg_UAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=zv9_9hqRWm8A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221201.503398706@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Dave Airlie <airlied@redhat.com>
Subject: [54/65] drm/radeon: check incoming cliprects pointer
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0054-drm-radeon-check-incoming-cliprects-pointer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit fefaedcfb82d2e57c2320acf60604ab03b750cc0 ]

The "boxes" parameter points into userspace memory. It should be verified
like any other operation against user memory.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/r300_cmdbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/r300_cmdbuf.c b/drivers/gpu/drm/radeon/r300_cmdbuf.c
index 1fe98b4..9aa02be 100644
--- a/drivers/gpu/drm/radeon/r300_cmdbuf.c
+++ b/drivers/gpu/drm/radeon/r300_cmdbuf.c
@@ -74,7 +74,7 @@ static int r300_emit_cliprects(drm_radeon_private_t *dev_priv,
 		OUT_RING(CP_PACKET0(R300_RE_CLIPRECT_TL_0, nr * 2 - 1));
 
 		for (i = 0; i < nr; ++i) {
-			if (DRM_COPY_FROM_USER_UNCHECKED
+			if (DRM_COPY_FROM_USER
 			    (&box, &cmdbuf->boxes[n + i], sizeof(box))) {
 				DRM_ERROR("copy cliprect faulted\n");
 				return -EFAULT;
-- 
1.7.10.4


