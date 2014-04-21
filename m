Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaDUEgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:36:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaDUEer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:34:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.13 07/32] ACPI / button: Add ACPI Button event via netlink routine
Date: Sun, 20 Apr 2014 19:13:24 -0700
Message-Id: <20140421021134.874432521@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/button.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -302,6 +302,10 @@ static void acpi_button_notify(struct ac
 			input_sync(input);
 
 			pm_wakeup_event(&device->dev, 0);
+			acpi_bus_generate_netlink_event(
+					device->pnp.device_class,
+					dev_name(&device->dev),
+					event, ++button->pushed);
 		}
 		break;
 	default:


