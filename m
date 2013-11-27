Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3K0ByX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:54:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662Ab3K0A5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.10 24/80] ACPI / hotplug: Do not execute "insert in progress" _OST
Date: Tue, 26 Nov 2013 16:56:53 -0800
Message-Id: <20131127005642.615825419@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 176a88d79d6b5aebabaff16734e8b3107efcaaad upstream.

According to the ACPI spec (5.0, Section 6.3.5), the "Device
insertion in progress (pending)" (0x80) _OST status code is
reserved for the "Insertion Processing" (0x200) source event
which is "a result of an OSPM action".  Specifically, it is not
a notification, so that status code should not be used during
notification processing, which unfortunately is done by
acpi_scan_bus_device_check().

For this reason, drop the ACPI_OST_SC_INSERT_IN_PROGRESS _OST
status evaluation from there (it was a mistake to put it in there
in the first place).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -244,8 +244,6 @@ static void acpi_scan_bus_device_check(a
 			goto out;
 		}
 	}
-	acpi_evaluate_hotplug_ost(handle, ost_source,
-				  ACPI_OST_SC_INSERT_IN_PROGRESS, NULL);
 	error = acpi_bus_scan(handle);
 	if (error) {
 		acpi_handle_warn(handle, "Namespace scan failure\n");


