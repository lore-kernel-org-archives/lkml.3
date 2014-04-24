Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbaDXK5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:57:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46558 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbaDXIxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 067/182] ACPI / button: Add ACPI Button event via netlink routine
Date: Thu, 24 Apr 2014 09:49:52 +0100
Message-Id: <1398329507-5911-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 0bf6368ee8f25826d0645c0f7a4f17c8845356a4 upstream.

Commit 1696d9d (ACPI: Remove the old /proc/acpi/event interface)
removed ACPI Button event which originally was sent to userspace via
/proc/acpi/event. This caused ACPI shutdown regression on gentoo
in VirtualBox. Now ACPI events are sent to userspace via netlink,
so add ACPI Button event back via netlink routine.

References: https://bugzilla.kernel.org/show_bug.cgi?id=71721
Reported-and-tested-by: Richard Musil <richard.musil@gmail.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/button.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index d2e617b..a495adb 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -302,6 +302,10 @@ static void acpi_button_notify(struct acpi_device *device, u32 event)
 			input_sync(input);
 
 			pm_wakeup_event(&device->dev, 0);
+			acpi_bus_generate_netlink_event(
+					device->pnp.device_class,
+					dev_name(&device->dev),
+					event, ++button->pushed);
 		}
 
 		acpi_bus_generate_proc_event(device, event, ++button->pushed);
-- 
1.9.1

