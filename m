Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422680Ab3AXVYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:24:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:40904 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126Ab3AXVQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:16:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thomas Schlichter <thomas.schlichter@web.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 21/22] ACPI / processor: Get power info before updating the C-states
Date: Thu, 24 Jan 2013 13:15:42 -0800
Message-Id: <20130124211511.549567120@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211504.701368763@linuxfoundation.org>
References: <20130124211504.701368763@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Schlichter <thomas.schlichter@web.de>

commit f427e5f1cf75bba84cccdac1d8a90552d9ae1065 upstream.

acpi_processor_get_power_info() has to be called before
acpi_processor_setup_cpuidle_states() to have the latest
information available. This fixes the missing C-state information
after AC-->DC transition.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/processor_idle.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1208,6 +1208,7 @@ int acpi_processor_cst_has_changed(struc
 		}
 
 		/* Populate Updated C-state information */
+		acpi_processor_get_power_info(pr);
 		acpi_processor_setup_cpuidle_states(pr);
 
 		/* Enable all cpuidle devices */


