Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab3FQL6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:58:19 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:52809 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932610Ab3FQL6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:58:16 -0400
Message-ID: <1371470294.26299.21.camel@x61.thuisdomein>
Subject: [PATCH] drm/tegra: Include linux/types.h
From: Paul Bolle <pebolle@tiscali.nl>
To: David Airlie <airlied@linux.ie>, Stephen Warren <swarren@wwwdotorg.org>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Jun 2013 13:58:14 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2013 11:58:14.0893 (UTC) FILETIME=[F2B711D0:01CE6B51]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"make headers_check" complains about include/uapi/drm/tegra_drm.h:
    [...]/usr/include/drm/tegra_drm.h:21: found __[us]{8,16,32,64} type without #include <linux/types.h>

So let's include linux/types.h in this header.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only with "make headers_check". I don't actually build or run
code that uses tegra_drm.h.

 include/uapi/drm/tegra_drm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
index 6e132a2..6698e81 100644
--- a/include/uapi/drm/tegra_drm.h
+++ b/include/uapi/drm/tegra_drm.h
@@ -17,6 +17,8 @@
 #ifndef _UAPI_TEGRA_DRM_H_
 #define _UAPI_TEGRA_DRM_H_
 
+#include <linux/types.h>
+
 struct drm_tegra_gem_create {
 	__u64 size;
 	__u32 flags;
-- 
1.8.1.4

