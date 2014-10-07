Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaJGMBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:01:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27958 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaJGMB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:01:28 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-af-5433d6161030
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR E...),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 0/4] drm/exynos/dsi: remove global display variable
Date: Tue, 07 Oct 2014 14:01:07 +0200
Message-id: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t/xK7pi14xDDG7cZbe4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaL3gVX2SzONr1ht7i8aw6bxYzz+5gs1h4BKp4x+SWbA5fH/e7jTB59W1Yx
	enzeJBfAHMVlk5Kak1mWWqRvl8CV8bq/h6ngLXvFxIWnmRoY97J1MXJySAiYSFx5uJwFwhaT
	uHBvPVCci0NIYCmjRNe256wQTh+TRNP0k6wgVWwCmhJ/N98E6xYRUJZYta+dHaSIWWAHs8TR
	S0eZQBLCAs4Sz9e/YgaxWQRUJa6fOQJm8wLF1169wQqxTk7i5LHJrBMYuRcwMqxiFE0tTS4o
	TkrPNdIrTswtLs1L10vOz93ECAmZrzsYlx6zOsQowMGoxMO7Qss4RIg1say4MvcQowQHs5II
	7+mLQCHelMTKqtSi/Pii0pzU4kOMTBycUg2Mq2WyVQoi/fM3H2eTNI9+vjV5bbbV+gzBybNZ
	N96VXFfgrL2w+8MuYc7bU/7qZj0oOfopVf2n2KadFRNjHqWdO/cgzU57ffKmyuUcs38KiL3O
	PneRKdppQ6WsiuSdUs3Ft6S6hR1DM6fZWT949+h905agDYmKj0y6n/554DJzY6rMlcfTnvHx
	KbEUZyQaajEXFScCAGahcsH3AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Inki,

Many Exynos DRM drivers uses global variables to represent associated devices
in Exynos DRM internal framework. It is quite confusing, it adds data duplication
and finally it does not allow to handle more than one device in system.
It seems better to embed such structures in private context of the device.

The patchset is based on exynos_drm_next plus my patch [1]:
'drm/exynos: remove explicit encoder/connector de-initialization'.

If the patchset is OK for you I can prepare similar patches for other Exynos DRM components.

[1]: https://lkml.org/lkml/2014/9/22/148

Regards
Andrzej


Andrzej Hajda (4):
  drm/exynos/dsi: remove global variable exynos_dsi_display
  drm/exynos/dsi: simplify device pointer evaluation
  drm/exynos/dsi: remove redundant encoder field
  drm/exynos/dsi: stop using display->ctx pointer

 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 96 ++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 49 deletions(-)

-- 
1.9.1

