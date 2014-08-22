Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaHVHxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:53:23 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34637 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaHVHxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:21 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-f8-53f6f6efd6fb
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
Subject: [PATCH 00/15] drm/exynos/ipp: image post processing fixes and
 improvements, part four
Date: Fri, 22 Aug 2014 09:52:11 +0200
Message-id: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJMWRmVeSWpSXmKPExsVy+t/xq7rvv30LNvjxkM/i1rpzrBZXvr5n
	s5h0fwKLxYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHTo/73ceZPPq2rGL0+LxJ
	LoA5issmJTUnsyy1SN8ugSvj6O/9LAVHuSu+brvJ2MC4j7OLkZNDQsBEYt/pWYwQtpjEhXvr
	2boYuTiEBJYyStz7tIYZwuljkjj9YgYzSBWbgKbE38032UBsEQFliVX72tlBipgFPjJJXFn6
	BqxIWCBB4vidpewgNouAqsT7lwfBGngFnCUurmpkg1gnJ3Hy2GTWCYzcCxgZVjGKppYmFxQn
	peca6hUn5haX5qXrJefnbmKEBMqXHYyLj1kdYhTgYFTi4U38/TVYiDWxrLgy9xCjBAezkgjv
	pnnfgoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwxt46ZHtraveWFimexfEK1so+WdxMvL+3r81+
	rah3haX/neCkGOEtN2bwdj3c9OHjsowpJfeXd3OU3nhht/xIWj9DhNutyomW84riRA7FFmyZ
	VBlrl7xFr2jDG+3oEgNrhjUPP6eZCp9hOt5v9ujK6TVVL3+USievzpxqVrlGlvflJgvTg9ra
	SizFGYmGWsxFxYkAFhNmsfIBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches contains various improvement and fixes
for exynos_drm ipp framework.
The patchset is based on exynos-drm-next branch.

IPP framework was tested for regressions on exynos4210-trats target.

Regards
Andrzej


Andrzej Hajda (15):
  drm/exynos/ipp: remove fake pm callbacks
  drm/exynos/ipp: cancel works before command node clean
  drm/exynos/ipp: move file reference from memory to command node
  drm/exynos/ipp: remove only related commands on file close
  drm/exynos/ipp: remove unused field in command node
  drm/exynos/ipp: free partially allocated resources on error
  drm/exynos/ipp: move nodes cleaning to separate function
  drm/exynos/ipp: clean memory nodes on command node cleaning
  drm/exynos/ipp: replace work_struct casting with better constructs
  drm/exynos/ipp: stop hardware before freeing memory
  drm/exynos/ipp: remove events during command cleaning
  drm/exynos/fimc: avoid clearing overflow bits
  drm/exynos/fimc: do not enable fimc twice
  drm/exynos/fimc: simplify buffer queuing
  drm/exynos/fimc: fix source buffer registers

 drivers/gpu/drm/exynos/exynos_drm_fimc.c    |  90 ++-----
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     |   3 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c     | 369 ++++++++++++----------------
 drivers/gpu/drm/exynos/exynos_drm_ipp.h     |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c |   3 +-
 5 files changed, 180 insertions(+), 289 deletions(-)

-- 
1.9.1

