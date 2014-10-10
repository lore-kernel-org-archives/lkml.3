Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaJJMcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:32:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20578 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJJMcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:32:15 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-3b-5437d1ccd3e3
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org (open list),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...)
Subject: [PATCH 0/4] drm/exynos: misc fixes
Date: Fri, 10 Oct 2014 14:31:52 +0200
Message-id: <1412944316-27737-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJMWRmVeSWpSXmKPExsVy+t/xq7pnLpqHGHzfZWRxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXRvf0CY8Fnnoq1s/8yNjAe5epi5OSQEDCRmNt0lAXCFpO4cG89
	WxcjF4eQwFJGiQ+LrkE5fUwS3etegVWxCWhK/N18kw3EFhFQlli1r50dpIhZ4COTxJWlb5hB
	EsIC2hKN33oYuxg5OFgEVCVO36wACfMKOEscu98ItU1O4uSxyawTGLkXMDKsYhRNLU0uKE5K
	zzXUK07MLS7NS9dLzs/dxAgJky87GBcfszrEKMDBqMTDe0HGPESINbGsuDL3EKMEB7OSCO/8
	vUAh3pTEyqrUovz4otKc1OJDjEwcnFINjA1mr1Vl9tVwF8xXj/m3ePH3Pj+9zOzNan+8T8Rx
	5wj/vM15ce7J1WdTKpk3nTz69vsVt/xpc/0EAtafddSr/6j+zdtXv+rwzJCek5JmCzgPzIt+
	9Kz2puSXn3ufOv1at3D2WfbTXJrHZs8TmSTtu7pJ6nwQ5/KO/Z8YbeufqP4WMTJ+MkND4asS
	S3FGoqEWc1FxIgBDFgYL8QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Inki,

These four independent patches fixes few problems I have encountered recently.

1st patch is a trivial fix.

2nd patch(kms poll init) fixes old issue, which became more visible after my patch
'drm/exynos: init vblank with real number of crtcs' - driver tried to handle HPD
events even if it was not fully initialized, it caused WARNs and app locks.

Vblank patch is slightly different version of the one proposed in [1]. The only
difference is that it enables vblank after dpms on, it is neccessary because
drm_crtc_vblank_on can call drm_vblank_enable which can call exynos_drm_crtc_enable_vblank
and exynos_drm_crtc_enable_vblank will return error if exynos_crtc->dpms != DRM_MODE_DPMS_ON.

DPMS patch was previously sent as a part of other series, but as the series have been dropped
I have resend it in this patchset.

The patchset is based on exynos-drm-next branch plus following patches:
    drm/exynos: remove explicit encoder/connector de-initialization
    drm/exynos: init vblank with real number of crtcs
    drm/exynos: remove ifdeferry from initialization code


It has been tested on trats board.

[1]: https://lkml.org/lkml/2014/10/2/154

Regards
Andrzej


Andrzej Hajda (4):
  drm/exynos: propagate plane initialization errors
  drm/exynos: init kms poll at the end of initialization
  drm/exynos: enable vblank after DPMS on
  drm/exynos: correct connector->dpms field before resuming

 drivers/gpu/drm/exynos/exynos_drm_crtc.c |  5 ++++-
 drivers/gpu/drm/exynos/exynos_drm_drv.c  | 27 +++++++++++++++++----------
 2 files changed, 21 insertions(+), 11 deletions(-)

-- 
1.9.1

