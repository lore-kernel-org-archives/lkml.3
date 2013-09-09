Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab3IIIgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:36:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:51118 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab3IIIgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,866,1371106800"; 
   d="scan'208";a="398652431"
Message-ID: <522D88C3.7000808@intel.com>
Date: Mon, 09 Sep 2013 16:37:23 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Lee Chun-Yi <jlee@novell.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 0/2] Rework ACPI video driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI video module provides two functionalities: backlight control
and backlight hotkey event delivery. It is possible the backlight
control interface is broken while the system still needs its event
delivery, so it's worth to seperate the two interfaces clearly.

This patchset has two patches, the first is to sepeate the two
interfaces in the ACPI video module and the second one solves some
Win8 backlight control problems by removing ACPI video's backlight
interface while still keeping its event delivery functionality. Due
to some systems whose firmware claims win8 compatible have problems
with i915's backlight control interface, a module param is introduced
to give user a chance to select if they want to remove ACPI video's
backlight control interface. The param is set to false by default.

Aaron Lu (2):
  ACPI / video: seperate backlight control and event interface
  ACPI / video / i915: Remove ACPI backlight if firmware expects Windows
    8

 drivers/acpi/internal.h         |   2 +
 drivers/acpi/video.c            | 473 +++++++++++++++++++++++-----------------
 drivers/acpi/video_detect.c     |  15 +-
 drivers/gpu/drm/i915/i915_dma.c |   2 +-
 drivers/gpu/drm/i915/i915_drv.c |   5 +
 drivers/gpu/drm/i915/i915_drv.h |   1 +
 include/acpi/video.h            |  11 +-
 include/linux/acpi.h            |   1 +
 8 files changed, 310 insertions(+), 200 deletions(-)

-- 
1.8.4.12.g2ea3df6

