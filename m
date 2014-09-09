Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaIINQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:16:59 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38620 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaIINQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:16:57 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d8-540efdc62544
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
Subject: [PATCH 0/9] drm/exynos: initialization/deinitialization fixes
Date: Tue, 09 Sep 2014 15:16:04 +0200
Message-id: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t/xK7rH/vKFGGz4zGdxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXx80EjY8EUroqL346zNTBu4+hi5OSQEDCRmL14GTOELSZx4d56
	NhBbSGApo8TPxSpdjFxAdh+TxPrZf5lAEmwCmhJ/N98EKxIRUJZYta+dHaSIWeAjk8SVpW/A
	JgkLuEl8XfoUqIiDg0VAVWLGRFuQMK+Ak8S9ixOZIJbJSZw8Npl1AiP3AkaGVYyiqaXJBcVJ
	6blGesWJucWleel6yfm5mxghQfJ1B+PSY1aHGAU4GJV4eCeW8YUIsSaWFVfmHmKU4GBWEuG1
	fgEU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwDhf44hh1++30pnRnHELr7ywPLo7dI3706wSH151
	m4KnaY17llzee2dKyNv8kh5haY44pdPVnGvOWzxY8Jvjjmnui4KnC9SDd91wvrhwyla187mP
	q1cvlkmcuf7HCUnRK4dZjs1On6nHIvH9Blv+6gmZrx79uHCfQWfTGm6bgHuPX/JPan5o3OCg
	xFKckWioxVxUnAgANLyEdfABAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches contains fixes of initialization and deinitialization
code of exynos_drm core and components.
It is based on exynos-drm-next branch.

Patchset has been tested on trats and universal_c210 platforms.

Regards
Andrzej


Andrzej Hajda (9):
  drm/exynos/ipp: traverse ipp drivers list safely
  drm/exynos: fix drm driver de-initialization order
  drm/exynos/fbdev: fix fbdev gem object cleanup
  drm/exynos/fb: free exynos framebuffer on error
  drm/exynos/crtc: fix framebuffer reference sequence
  drm/exynos/dsi: unregister connector on removal
  drm/exynos/dpi: unregister connector and panel on removal
  drm/exynos/dp: unregister connector on removal
  drm/exynos/hdmi: unregister connector on removal

 drivers/gpu/drm/exynos/exynos_dp_core.c   | 4 +++-
 drivers/gpu/drm/exynos/exynos_drm_crtc.c  | 6 ++++++
 drivers/gpu/drm/exynos/exynos_drm_dpi.c   | 6 +++++-
 drivers/gpu/drm/exynos/exynos_drm_drv.c   | 8 ++++----
 drivers/gpu/drm/exynos/exynos_drm_dsi.c   | 9 ++++++---
 drivers/gpu/drm/exynos/exynos_drm_fb.c    | 1 +
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c | 3 ---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c   | 4 ++--
 drivers/gpu/drm/exynos/exynos_hdmi.c      | 4 +++-
 9 files changed, 30 insertions(+), 15 deletions(-)

-- 
1.9.1

