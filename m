Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3JAUsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:48:53 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62508 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751539Ab3JAUsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:48:50 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: 3.12.0-rc3: Symbol license change in commit caf5c03f (ACPI: Move acpi_bus_get_device() from bus.c to scan.c)
Date: Tue, 01 Oct 2013 23:00:16 +0200
Message-ID: <5459219.RfezHuQcWu@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <524AFF89.4080703@hurleysoftware.com>
References: <524AFF89.4080703@hurleysoftware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 01, 2013 12:59:53 PM Peter Hurley wrote:
> I have no love lost for proprietary modules but changing
> acpi_bus_get_device() symbol's license seems gratuitous considering
> the symbol pre-dates the mainline git tree and the code is just
> being moved from one source file to another.

Well, I didn't know whether or not any binary modules use that function in the
first place.

It looks like some of them do, so below is a revert of that change (that I'm
going to push for -rc4).

I wonder what module exactly you have in mind, though?

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI: Use EXPORT_SYMBOL() for acpi_bus_get_device()

Commit caf5c03f (ACPI: Move acpi_bus_get_device() from bus.c to
scan.c) caused acpi_bus_get_device() to be exported using
EXPORT_SYMBOL_GPL(), but that broke some binary drivers in
existence, so revert that change.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -968,7 +968,7 @@ int acpi_bus_get_device(acpi_handle hand
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(acpi_bus_get_device);
+EXPORT_SYMBOL(acpi_bus_get_device);
 
 int acpi_device_add(struct acpi_device *device,
 		    void (*release)(struct device *))

