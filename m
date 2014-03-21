Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008AbaCURcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:32:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18611 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaCURcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:32:04 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-f8-532c7792f586
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 0/4] devfreq: exynos: generalize PPMU code
Date: Fri, 21 Mar 2014 18:31:42 +0100
Message-id: <1395423106-30458-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t9jQd1J5TrBBr2HFS02zljPanH9y3NW
	i7NNb9gtLu+aw2bxufcIo8WM8/uYLG43rmCzeLziLbvF+hmvWRw4PRbvecnk0bdlFaPH501y
	AcxRXDYpqTmZZalF+nYJXBlb179hL9jDWdG4eRZjA+Mz9i5GTg4JAROJnRf+QNliEhfurWfr
	YuTiEBKYzijx+89/Zgini0mi7c4HFpAqNgEriYntqxhBbBEBY4lbj2+xghQxCxxjlHg34SUr
	SEIYqOjUgxtMIDaLgKpE0+7ZzCA2r4CHxLaL3xgh1ilKdD+bwDaBkXsBI8MqRtHUguSC4qT0
	XCO94sTc4tK8dL3k/NxNjOBAeSa9g3FVg8UhRgEORiUe3gpO7WAh1sSy4srcQ4wSHMxKIrzN
	sTrBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhhnWbad
	vP1O3lI/Z+61b5/cT/zznL1yVeLp9Vm/OLgYd54516H4Jy5gs5BvpWmtKedeN5uLxgUZvbc0
	0066d32WNdz8O+FtO+dqqQ65vRsXiznVL4wK7XTP7pzxaebS+zVrVOpWxkrI+z3YcfD5610P
	30xiYpyc+C9cQf7LpvnH3iUUBJkm5BkpsRRnJBpqMRcVJwIArmeewBACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series generalizes PPMU support for Exynos devfreq
drivers.

It is based on top of "devfreq: exynos: Fix minor issue and code
clean to remove legacy method" patch series from Chanwoo Choi
(https://lkml.org/lkml/2014/3/19/713).

Please note that the patches were only compile tested because
Exynos devfreq drivers don't work yet in the upstream kernels
(FWIW these changes were briefly tested with the internal tree
which has working devfreq drivers).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (3):
  devfreq: exynos4: introduce struct busfreq_ppmu_data
  devfreq: exynos5: introduce struct busfreq_ppmu_data
  devfreq: exynos: make more PPMU code common

Chanwoo Choi (1):
  devfreq: exynos4: use common PPMU code

 drivers/devfreq/exynos/Makefile      |   2 +-
 drivers/devfreq/exynos/exynos4_bus.c | 176 +++++++++--------------------------
 drivers/devfreq/exynos/exynos5_bus.c |  94 +++++--------------
 drivers/devfreq/exynos/exynos_ppmu.c |  60 ++++++++++++
 drivers/devfreq/exynos/exynos_ppmu.h |   8 ++
 5 files changed, 135 insertions(+), 205 deletions(-)

-- 
1.8.2.3

