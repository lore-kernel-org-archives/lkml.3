Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab3IQJXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 05:23:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:43461 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab3IQJXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 05:23:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,922,1371106800"; 
   d="scan'208";a="361626463"
From: Aaron Lu <aaron.lu@intel.com>
To: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v2 0/3] Fix Win8 backlight issue
Date: Tue, 17 Sep 2013 17:23:13 +0800
Message-Id: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.4.12.g2ea3df6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 has the subject of "Rework ACPI video driver" and is posted here:
http://lkml.org/lkml/2013/9/9/74
Since the objective is really to fix Win8 backlight issues, I changed
the subject in this version, sorry about that.

This patchset has three patches, the first introduced a new API named
backlight_device_registered in backlight layer that can be used for
backlight interface provider module to check if a specific type backlight
interface has been registered, see changelog for patch 1/3 for details.
Then patch 2/3 does the cleanup to sepeate the backlight control and
event delivery functionality in the ACPI video module and patch 3/3
solves some Win8 backlight control problems by avoiding register ACPI
video's backlight interface if:
1 Kernel cmdline option acpi_backlight=video is not given;
2 This is a Win8 system;
3 Native backlight control interface exists.

Technically, patch 2/3 is not required to fix the issue here. So if you
think it is not necessary, I can remove it from the series.

Apply on top of v3.12-rc1.

Aaron Lu (3):
  backlight: introduce backlight_device_registered
  ACPI / video: seperate backlight control and event interface
  ACPI / video: Do not register backlight if win8 and native interface
    exists

 drivers/acpi/internal.h             |   5 +-
 drivers/acpi/video.c                | 442 ++++++++++++++++++++----------------
 drivers/acpi/video_detect.c         |  14 +-
 drivers/video/backlight/backlight.c |  31 +++
 include/acpi/video.h                |   2 +
 include/linux/backlight.h           |   4 +
 6 files changed, 300 insertions(+), 198 deletions(-)

-- 
1.8.4.12.g2ea3df6

