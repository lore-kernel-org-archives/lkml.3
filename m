Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab3ERX1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 19:27:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34466 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab3ERX1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 19:27:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <liuj97@gmail.com>,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        linux-mm@kvack.org
Subject: [PATCH 2/5] ACPI / processor: Pass processor object handle to acpi_bind_one()
Date: Sun, 19 May 2013 01:31:33 +0200
Message-ID: <2218373.jD5mABWNeo@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2250271.rGYN6WlBxf@vostro.rjw.lan>
References: <2250271.rGYN6WlBxf@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make acpi_processor_add() pass the ACPI handle of the processor
namespace object to acpi_bind_one() instead of setting it directly
to allow acpi_bind_one() to catch possible bugs causing the ACPI
handle of the processor device to be set earlier.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_processor.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-pm/drivers/acpi/acpi_processor.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_processor.c
+++ linux-pm/drivers/acpi/acpi_processor.c
@@ -389,8 +389,7 @@ static int __cpuinit acpi_processor_add(
 	per_cpu(processor_device_array, pr->id) = device;
 
 	dev = get_cpu_device(pr->id);
-	ACPI_HANDLE_SET(dev, pr->handle);
-	result = acpi_bind_one(dev, NULL);
+	result = acpi_bind_one(dev, pr->handle);
 	if (result)
 		goto err;
 

