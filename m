Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbaEEM4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:56:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40980 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932219AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 30/50] ACPI / button: Add ACPI Button event via netlink routine
Date: Mon,  5 May 2014 14:43:12 +0200
Message-Id: <f437aa6910609ea707815c2af1621d7bd7a2a596.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/button.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index a55773801c5f..3aa89eb8dbbd 100644
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
 		break;
 	default:
-- 
1.9.2

