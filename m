Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab3CZLs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:48:57 -0400
Received: from mout.web.de ([212.227.17.12]:59465 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331Ab3CZLsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:48:55 -0400
From: Danny Baumann <dannybaumann@web.de>
To: David Airlie <airlied@linux.ie>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Danny Baumann <dannybaumann@web.de>
Subject: [PATCH 0/1] drm/i915: Allow specifying a minimum brightness level for sysfs control.
Date: Tue, 26 Mar 2013 12:48:44 +0100
Message-Id: <1364298525-4337-1-git-send-email-dannybaumann@web.de>
X-Mailer: git-send-email 1.8.1.4
X-Provags-ID: V02:K0:Xla/JBJN1xg8FYr26cVYj2fxVSGXjmPEUqYPrLmNjok
 eav81J3ApJQFCCFNg25DUILehik7coHitO2dcaN50AMHulUGiy
 QgjGTh5Eu0pyyDkLvBvbUtxWEfraKCRYPm93PY/ChH3Mkhhw1b
 t4myhAVKnHPk2uI2VjZiQDtIqnczm5S7gk/tiO+w5v3oW5OVTy
 uGWTgvqVOzt8XO8ZIzkqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the behaviour of the intel_backlight backlight device
consistent to e.g. acpi_videoX: When writing the value 0, the set brightness
makes the panel content barely readable instead of turning the backlight off.
This matches the expectations of user space (e.g. kde-workspace or the Intel
X11 driver), which expects that it can use intel_backlight as a drop-in
replacement for acpi_videoX.
As BIOSes written for Windows 8 support seem to expect the display driver
taking care of the brightness control instead of ACPI methods (see [1]),
I would expect quite a number of people (like me ;) ) having the need of
using intel_backlight instead of acpi_videoX. A quick Google search
indicated that most people are confused by the current behaviour, so I think
it's a good idea to make the default behaviour somehow match acpi_videoX.

Regards,

Danny

[1] https://bugzilla.kernel.org/show_bug.cgi?id=55071

Danny Baumann (1):
  drm/i915: Allow specifying a minimum brightness level for sysfs
    control.

 drivers/gpu/drm/i915/intel_panel.c | 48 ++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 7 deletions(-)

-- 
1.8.1.4

