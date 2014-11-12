Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbaKLBar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:30:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbaKLBan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:30:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.17 183/319] ACPI: invoke acpi_device_wakeup() with correct parameters
Date: Wed, 12 Nov 2014 10:15:21 +0900
Message-Id: <20141112011023.011929693@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 67598a1d3140a66f57aa6bcb8d22c4c2b7e910f5 upstream.

Fix a bug that invokes acpi_device_wakeup() with wrong parameters.

Fixes: f35cec255557 (ACPI / PM: Always enable wakeup GPEs when enabling device wakeup)
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/device_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -710,7 +710,7 @@ int acpi_pm_device_run_wake(struct devic
 		return -ENODEV;
 	}
 
-	return acpi_device_wakeup(adev, enable, ACPI_STATE_S0);
+	return acpi_device_wakeup(adev, ACPI_STATE_S0, enable);
 }
 EXPORT_SYMBOL(acpi_pm_device_run_wake);
 #endif /* CONFIG_PM_RUNTIME */


