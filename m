Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbaDVWDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 18:03:32 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51135 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbaDVWD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 18:03:27 -0400
Date: Tue, 22 Apr 2014 23:03:24 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1404222301180.1825@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1417472082-1398204204=:1825"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1417472082-1398204204=:1825
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

this is just radeon fixes, primarily the two pll fix and the aux fix,
it also disables dpm on rv770 gpus, fixes driver reloading, and
fixes two issues with runtime PM on some GPUS.

Dave.

The following changes since commit 4d0fa8a0f01272d4de33704f20303dcecdb55df1:

  Merge tag 'gpio-v3.15-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio (2014-04-22 09:28:02 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to abaafc0af9f74f8e6212a3bf54fb907358b40ad7:

  Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-next (2014-04-23 07:39:12 +1000)

----------------------------------------------------------------

Alex Deucher (7):
      drm/radeon: disable dpm on rv770 by default
      drm/radeon/aux: fix hpd assignment for aux bus
      drm/radeon: fix count in cik_sdma_ring_test()
      drm/radeon: properly unregister hwmon interface (v2)
      drm/radeon/pm: don't walk the crtc list before it has been initialized (v2)
      drm/radeon: fix ATPX detection on non-VGA GPUs
      drm/radeon: don't allow runpm=1 on systems with out ATPX

Christian König (2):
      drm/radeon: use fixed PPL ref divider if needed
      drm/radeon: improve PLL limit handling in post div calculation

Dave Airlie (1):
      Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-next

 drivers/gpu/drm/radeon/atombios_dp.c         |  1 +
 drivers/gpu/drm/radeon/cik_sdma.c            |  2 +-
 drivers/gpu/drm/radeon/r600_dpm.c            | 35 ++++++------
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |  7 +++
 drivers/gpu/drm/radeon/radeon_display.c      | 84 +++++++++++++++++++---------
 drivers/gpu/drm/radeon/radeon_kms.c          |  8 +--
 drivers/gpu/drm/radeon/radeon_pm.c           | 51 ++++++++++-------
 7 files changed, 120 insertions(+), 68 deletions(-)
--29444707-1417472082-1398204204=:1825--
