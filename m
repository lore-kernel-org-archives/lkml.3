Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaLSOBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:01:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaLSOBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:01:52 -0500
Date: Fri, 19 Dec 2014 06:00:33 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-6658c739431cfa1bdf15737774ed1cac432b5c35@git.kernel.org>
Cc: hpa@zytor.com, tony.luck@intel.com, bp@alien8.de, lenb@kernel.org,
        joro@8bytes.org, benh@kernel.crashing.org, yinghai@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, rjw@rjwysocki.net,
        jiang.liu@linux.intel.com, rdunlap@infradead.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com, mingo@kernel.org
Reply-To: tglx@linutronix.de, gregkh@linuxfoundation.org, yinghai@kernel.org,
        joro@8bytes.org, benh@kernel.crashing.org, lenb@kernel.org,
        bp@alien8.de, tony.luck@intel.com, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        bhelgaas@google.com, jiang.liu@linux.intel.com, rdunlap@infradead.org,
        rjw@rjwysocki.net
In-Reply-To: <1414387308-27148-6-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-6-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] ACPI:
  Correct return value of acpi_dev_resource_address_space()
Git-Commit-ID: 6658c739431cfa1bdf15737774ed1cac432b5c35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6658c739431cfa1bdf15737774ed1cac432b5c35
Gitweb:     http://git.kernel.org/tip/6658c739431cfa1bdf15737774ed1cac432b5c35
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:35 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:14 +0100

ACPI: Correct return value of acpi_dev_resource_address_space()

Change acpi_dev_resource_address_space() to return failure if the
acpi_resource structure can't be converted to an ACPI address64
structure, so caller could correctly detect failure.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <lenb@kernel.org>
Link: http://lkml.kernel.org/r/1414387308-27148-6-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/acpi/resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 2ba8f02..782a0d1 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -200,7 +200,7 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
 
 	status = acpi_resource_to_address64(ares, &addr);
 	if (ACPI_FAILURE(status))
-		return true;
+		return false;
 
 	res->start = addr.minimum;
 	res->end = addr.maximum;
