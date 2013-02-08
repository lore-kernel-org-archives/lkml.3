Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab3BHAVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:21:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60242 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab3BHAVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:21:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 1/2] ACPI / scan: Remove useless #ifndef from acpi_eject_store()
Date: Fri, 08 Feb 2013 01:25:08 +0100
Message-ID: <1498466.XkrmNzKycX@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1468930.acVuhKfKYv@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <5090866.2BHgpRnuEZ@vostro.rjw.lan> <1468930.acVuhKfKYv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since the FORCE_EJECT symbol is never defined, the
#ifndef FORCE_EJECT in acpi_eject_store() is always true, so drop it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    2 --
 1 file changed, 2 deletions(-)

Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -202,12 +202,10 @@ acpi_eject_store(struct device *d, struc
 	if ((!count) || (buf[0] != '1')) {
 		return -EINVAL;
 	}
-#ifndef FORCE_EJECT
 	if (!acpi_device->driver && !acpi_device->handler) {
 		ret = -ENODEV;
 		goto err;
 	}
-#endif
 	status = acpi_get_type(acpi_device->handle, &type);
 	if (ACPI_FAILURE(status) || (!acpi_device->flags.ejectable)) {
 		ret = -ENODEV;

