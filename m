Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaIOUym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:54:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbaIOT1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 103/158] ACPI / video: Fix use_native_backlight selection logic
Date: Mon, 15 Sep 2014 12:25:42 -0700
Message-Id: <20140915192545.973147655@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 25294e9f00f03b2b4f4c56e913bc8c573972f33b upstream.

Commit 751109aad583 ("ACPI / video: Change the default for
video.use_native_backlight to 1") has changed the default for
use_native_backlight from 0 to 1, but instead of changing
use_native_backlight_dmi to true, and leaving use_native_backlight_param at -1,
it has changed use_native_backlight_param to 1.

This causes acpi_video_use_native_backlight() to always think that a value was
specified through the param, making it impossible to add a dmi based quirk
to force 0 now that the default is 1.

This fixes this by restoring the use_native_backlight_param default to -1, and
instead setting the use_native_backlight_dmi default to true.

Fixes: 751109aad583 (ACPI / video: Change the default for video.use_native_backlight to 1)
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -82,9 +82,9 @@ module_param(allow_duplicates, bool, 064
  * For Windows 8 systems: used to decide if video module
  * should skip registering backlight interface of its own.
  */
-static int use_native_backlight_param = 1;
+static int use_native_backlight_param = -1;
 module_param_named(use_native_backlight, use_native_backlight_param, int, 0444);
-static bool use_native_backlight_dmi = false;
+static bool use_native_backlight_dmi = true;
 
 static int register_count;
 static struct mutex video_list_lock;


