Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaKLB0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:26:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaKLB0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:26:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeffrey Bastian <jbastian@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.17 108/319] drm/vmwgfx: Fix drm.h include
Date: Wed, 12 Nov 2014 10:14:06 +0900
Message-Id: <20141112011010.430603524@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@fedoraproject.org>

commit e351943b081f4d9e6f692ce1a6117e8d2e71f478 upstream.

The userspace drm.h include doesn't prefix the drm directory.  This can lead
to compile failures as /usr/include/drm/ isn't in the standard gcc include
paths.  Fix it to be <drm/drm.h>, which matches the rest of the driver drm
header files that get installed into /usr/include/drm.

Red Hat Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1138759

Fixes: 1d7a5cbf8f74e
Reported-by: Jeffrey Bastian <jbastian@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/drm/vmwgfx_drm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/drm/vmwgfx_drm.h
+++ b/include/uapi/drm/vmwgfx_drm.h
@@ -29,7 +29,7 @@
 #define __VMWGFX_DRM_H__
 
 #ifndef __KERNEL__
-#include <drm.h>
+#include <drm/drm.h>
 #endif
 
 #define DRM_VMW_MAX_SURFACE_FACES 6


