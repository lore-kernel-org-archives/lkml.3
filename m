Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3FYTH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:07:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3FYSdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 36/95] drm/prime: Honor requested file flags when exporting a buffer
Date: Tue, 25 Jun 2013 11:32:23 -0700
Message-Id: <20130625182157.721591509@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit ebc0bad4a05ad63979e8bc115cea3b8abdf814c7 upstream.

The DRM PRIME API passes file flags to the driver for the exported
buffer. Honor them instead of hardcoding 0600.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_prime.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -190,8 +190,7 @@ struct dma_buf *drm_gem_prime_export(str
 		if (ret)
 			return ERR_PTR(ret);
 	}
-	return dma_buf_export(obj, &drm_gem_prime_dmabuf_ops, obj->size,
-			      0600);
+	return dma_buf_export(obj, &drm_gem_prime_dmabuf_ops, obj->size, flags);
 }
 EXPORT_SYMBOL(drm_gem_prime_export);
 


