Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641AbaH1JIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:08:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54124 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934800AbaH1JIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:12 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-99-53fef179c804
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
Subject: [PATCH v2 00/17] drm/exynos/ipp: image post processing fixes and
 improvements, part four
Date: Thu, 28 Aug 2014 11:07:24 +0200
Message-id: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJMWRmVeSWpSXmKPExsVy+t/xy7qVH/8FG7yapGZxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVx4N4mxoIjfBXPL29ha2D8zt3FyMkhIWAi8ebWIRYIW0ziwr31
	bF2MXBxCAksZJfZdXgvl9DFJLD50nBWkik1AU+Lv5ptsILaIgLLEqn3t7CBFzAIfmSSuLH3D
	3MXIwSEskCwxc2I4SA2LgKrEuyMnGEFsXgFnieYjx5ghtslJnDw2mXUCI/cCRoZVjKKppckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGCFh8mUH4+JjVocYBTgYlXh4N5T+CxZiTSwrrsw9xCjBwawk
	wnv0OFCINyWxsiq1KD++qDQntfgQIxMHp1QDI5eH5aXL+2eIKVl33n+qPuVAVGXa59JWdx6P
	Of9mr7g4bd2LF/0eWnwqKqF8Gf62/zRWLd/T2yIVv6htz39RNT3myAD7l7wFPJrV8+89rP1y
	eq9GUZZE0XQ1jwXdPBX+ezv9VjyeJjL1u9fmP0z3u7Z9kok/7JB7o1N9XeLr2hMaB/pu1wvz
	KLEUZyQaajEXFScCAPJt0PnxAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches contains various improvement and fixes
for exynos_drm ipp framework.
The patchset is based on exynos-drm-next branch.

IPP framework was tested for regressions on exynos4210-trats target.

In the 2nd version of the series I have included changes proposed by Joonyoung Shim.
I have decided to resend whole series because the changes caused merge conflicts and
two separate patches have been added to the series.
Changes are described in comit messages.

Regards
Andrzej


Andrzej Hajda (17):
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
  drm/exynos/ipp: remove file argument from node related functions
  drm/exynos/ipp: add file checks for ioctls

 drivers/gpu/drm/exynos/exynos_drm_fimc.c    |  90 ++-----
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     |   3 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c     | 397 ++++++++++++----------------
 drivers/gpu/drm/exynos/exynos_drm_ipp.h     |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c |   3 +-
 5 files changed, 195 insertions(+), 302 deletions(-)

-- 
1.9.1

