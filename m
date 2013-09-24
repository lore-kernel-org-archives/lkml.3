Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3IXJrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:47:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:13092 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab3IXJq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:46:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,969,1371106800"; 
   d="scan'208";a="364767587"
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
        Aaron Lu <aaron.lu@intel.com>, Ben Jencks <ben@bjencks.net>,
        Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: [PATCH v3 0/4] Fix Win8 backlight issue
Date: Tue, 24 Sep 2013 17:47:28 +0800
Message-Id: <1380016052-15315-1-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.4.12.g2ea3df6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3:
1 Add a new patch 4/4 to fix some problems in thinkpad-acpi module;
2 Remove unnecessary function acpi_video_unregister introduced in
  patch 2/3 as pointed out by Jani Nikula.

v2:
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

Aaron Lu (4):
  backlight: introduce backlight_device_registered
  ACPI / video: seperate backlight control and event interface
  ACPI / video: Do not register backlight if win8 and native interface
    exists
  thinkpad-acpi: fix handle locate for video and query of _BCL

 drivers/acpi/internal.h              |   5 +-
 drivers/acpi/video.c                 | 442 ++++++++++++++++++++---------------
 drivers/acpi/video_detect.c          |  14 +-
 drivers/platform/x86/thinkpad_acpi.c |  31 ++-
 drivers/video/backlight/backlight.c  |  31 +++
 include/acpi/video.h                 |   2 +
 include/linux/backlight.h            |   4 +
 7 files changed, 324 insertions(+), 205 deletions(-)

-- 
1.8.4.12.g2ea3df6

