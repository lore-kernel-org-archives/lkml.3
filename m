Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161037Ab3AXVaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:30:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:40417 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756895Ab3AXVOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Leonid Isaev <lisaev@umail.iu.edu>, Borislav Petkov <bp@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 39/46] cpufreq: Add module aliases for acpi-cpufreq
Date: Thu, 24 Jan 2013 13:13:17 -0800
Message-Id: <20130124211150.270799021@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <matthew.garrett@nebula.com>

commit efa17194581bdfca0986dabc178908bd7c21ba00 upstream.

The acpi core will call request_module("acpi-cpufreq") on subsystem init,
but this will fail if the module isn't available at that stage of boot.
Add some module aliases to ensure that udev can load the module on Intel
and AMD systems with the appropriate feature bits - I /think/ that this
will also work on VIA systems, but haven't verified that.

References: http://lkml.kernel.org/r/1448223.sdUJnNSRz4@vostro.rjw.lan
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Tested-by: Leonid Isaev <lisaev@umail.iu.edu>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/acpi-cpufreq.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -1030,4 +1030,11 @@ MODULE_PARM_DESC(acpi_pstate_strict,
 late_initcall(acpi_cpufreq_init);
 module_exit(acpi_cpufreq_exit);
 
+static const struct x86_cpu_id acpi_cpufreq_ids[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_ACPI),
+	X86_FEATURE_MATCH(X86_FEATURE_HW_PSTATE),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, acpi_cpufreq_ids);
+
 MODULE_ALIAS("acpi");


