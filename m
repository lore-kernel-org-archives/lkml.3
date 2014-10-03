Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaJCIYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:24:34 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19974 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaJCIYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:24:30 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-40-542e5d3aba6e
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org (open list:DRM DRIVERS)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        intel-gfx@lists.freedesktop.org (open list:INTEL DRM DRIVERS...)
Subject: [PATCH RFC 0/4] drm/core: restore suspend/resume calbacks in KMS drm
 drivers
Date: Fri, 03 Oct 2014 10:24:09 +0200
Message-id: <1412324653-30677-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e/4VV2rWL0Qgx3bLSxurTvHatF77iST
	xfIz65gtrnx9z2Yx6f4EFovZEzYDxS6vZ7R4ce8ii0XvgqtsFmeb3rBbXN41h81ixvl9TBZr
	j9xlt5gx+SWbA5/H4j0vmTy2f3vA6jHvZKDH/e7jTB59W1YxenzeJBfAFsVlk5Kak1mWWqRv
	l8CVsbXnN1PBXY6Ka0fmMzUw9rB3MXJySAiYSKxqOcoGYYtJXLi3Hsjm4hASWMooMevgPBYI
	p49JYvqU76wgVWwCmhJ/N98EquLgEBGwlrg2SRakhlmgl1Xi25VmZpAaYYFwiZWNv8A2sAio
	SjyYP5UFxOYVcJZYsHYy1GY5iZPHJrNOYORewMiwilE0tTS5oDgpPddQrzgxt7g0L10vOT93
	EyMk6L7sYFx8zOoQowAHoxIP78cbuiFCrIllxZW5hxglOJiVRHgnR+mFCPGmJFZWpRblxxeV
	5qQWH2Jk4uCUamBcdPvNbS1Ppoi65CwrFuXyawfVH5VEOHnV7na8Uf4xf/tSu1C15+K/f04L
	1/v0Kii6JmlSjm29RtPGuOrpat3S6srJx269m7Ejhm3OmxsBaid3Zlz480Q8ud5r9zQrlu/b
	JBT3+XisPXjMwF/g6sxn54Xevu1+FXV53WL3e+mbshUbN93p4ZquxFKckWioxVxUnAgAEjQg
	thgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main intent of this patchset is to allow use of suspend/resume drm driver
callbacks in KMS drivers, as these callbacks seems to me the best place
to implement suspend/resume functionality in drm driver.
Implementing this functionality in master component driver PM ops is problematic
as those callbacks can be called asynchronously regardless of state/existence of
drm device, thus it would require additional synchronization mechanism.

Callbacks re-enabling requires small changes in i915 and exynos driver.
The patchset contains also fix of exynos resume callback.

Regards
Andrzej


Andrzej Hajda (4):
  drm/i915: set PM callbacks only if modeset is turned off
  drm/core: re-enable suspend/resume callbacks for KMS drivers
  drm/exynos: remove master component PM callbacks
  drm/exynos: correct connector->dpms field before resuming

 drivers/gpu/drm/drm_sysfs.c             |  2 --
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 37 ++++++---------------------------
 drivers/gpu/drm/i915/i915_drv.c         |  6 ++----
 3 files changed, 8 insertions(+), 37 deletions(-)

-- 
1.9.1

