Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaESK5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:57:25 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37984 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbaESKyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:54:31 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-45-5379e2e4878a
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...)
Subject: [PATCH 1/8] drm/exynos/ipp: fix get_property IOCTL
Date: Mon, 19 May 2014 12:54:03 +0200
Message-id: <1400496850-23860-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
References: <1400496850-23860-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7pPHlUGG6xvkbe4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4MrofHiDteApa8XzPa+ZGxjfsnQxcnBICJhI7Lyr3sXICWSKSVy4
	t56ti5GLQ0hgKaPEt397WSCcPiaJV/N3s4NUsQloSvzdfJMNxBYR0JG43tPNDFLELPCMSeLO
	3XVgRcIC1hJ7tx1gBLFZBFQlDm6bxwpi8wo4S1x4PocdYp2cxMljk8HinAIuEieOLQezhYBq
	Hu86yj6BkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJCw+rKDcfExq0OMAhyMSjy8
	HxIqg4VYE8uKK3MPMUpwMCuJ8G67ARTiTUmsrEotyo8vKs1JLT7EyMTBKdXAaPRCV/2s6s93
	53PvWNr7Ps+NuB781ZohbucGqdst1+RCnc75XlwemLZN/O1Uz6lZex/G77gTuiCQre64SHOh
	jmCQUJ1VzM09zyuvOKiy7TnicNF93p4rUSsD7z3OPGea5bZ/KXNNeXd0h8U/NSmhiX+udphX
	KhgmTHLZESY/ubEw9e2Fo/WnlFiKMxINtZiLihMBJUKfXwkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to incorrect assignment in EXYNOS_IPP_GET_PROPERTY
IOCTL handler this IOCTL did not work at all.
The patch fixes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 09312b8..5aaf21f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -346,7 +346,7 @@ int exynos_drm_ipp_get_property(struct drm_device *drm_dev, void *data,
 			return PTR_ERR(ippdrv);
 		}
 
-		prop_list = ippdrv->prop_list;
+		*prop_list = *ippdrv->prop_list;
 	}
 
 	return 0;
-- 
1.9.1

