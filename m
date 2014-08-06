Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaHFKqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:46:52 -0400
Received: from mx2.digadd.de ([195.47.195.236]:37565 "EHLO mx1.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752943AbaHFKqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:46:51 -0400
X-Greylist: delayed 1220 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2014 06:46:51 EDT
Message-ID: <53E202A6.3080002@digadd.de>
Date: Wed, 06 Aug 2014 12:25:42 +0200
From: Christian Schmidt <schmidt@digadd.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: i2c-i801 vs. ACPI driver to access SMBUS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a small issue with the i2c-i801 driver. It does not register the
i2c adaptor due to an ACPI resource conflict:

[11074.459747] ACPI Warning: SystemIO range
0x000000000000f000-0x000000000000f01f conflicts with OpRegion
0x000000000000f000-0x000000000000f00f (\_SB_.PCI0.SBUS.SMBI)
(20140214/utaddress-258)
[11074.459761] ACPI: If an ACPI driver is available for this device, you
should use it instead of the native driver

With the code:
        err = acpi_check_resource_conflict(&dev->resource[SMBBAR]);
        if (err) {
                err = -ENODEV;
                goto exit;
        }

silently not activating the driver, however it still shows up in lspci
-k. Commenting out the above code makes the driver provide the smbus
interface as expected,

The question is: Is there any existing ACPI driver for this? I can't
find any either under ACPI or i2c (i2c-scmi does not work for this).

Regards,
Christian

PS: Please CC: me on replies as I am not subscribed to the list.
