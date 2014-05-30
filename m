Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbaE3MHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:07:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52588 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751115AbaE3MHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:07:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 0/5] I2C ACPI operation region handler
Date: Fri, 30 May 2014 14:24:12 +0200
Message-ID: <10091506.iBigojlNVE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53881E87.9070706@intel.com>
References: <1400590764-11108-1-git-send-email-tianyu.lan@intel.com> <53881E87.9070706@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 30, 2014 02:00:39 PM Lan Tianyu wrote:
> On 05/20/2014 08:59 PM, Lan Tianyu wrote:
> > ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart) operation
> > region. It allows ACPI aml code able to access such kind of devices to
> > implement some ACPI standard method.
> >
> > On the Asus T100TA, Bios use GenericSerialBus operation region to access
> > i2c device to get battery info. So battery function depends on the I2C
> > operation region support. Here is the bug link.
> > https://bugzilla.kernel.org/show_bug.cgi?id=69011
> >
> 
> Hi Wolfram:
> 	Since this version resolved all comments, it's ok for you?

BTW, patches [2-3/5] are already queued up for 3.16 as they are independent of
the i2c changes.

> 
> > Change since V2:
> >          Drop patchs of adding I2C smbus quick read/write and word/block
> > process call functions because not find machines supporting such protocols
> > so far and can't test these functions.
> >          Merge patchs of "I2C ACPI related code clear up" and "Add CONFIG_I2C_ACPI
> > config"
> > 	Patch 2: Add acpi_bus_detach_private_data() function to detach data from
> > ACPI handle and replace ACPI_ERROR() with acpi_handle_debug() to avoid some redundant
> > error log.
> >
> > Change since V1:
> >         Fix some code style issues. Change prefix i2c_acpi to acpi_i2c.
> > Move ACPI related code in the i2c core to i2c-acpi.c. Add CONFIG_I2C_ACPI
> > and make i2c core built-in when it's set to avoid i2c ACPI operation region
> > being removed.
> >
> > Lan Tianyu (5):
> >    ACPICA: Export acpi_buffer_to_resource symbol
> >    ACPI: Add acpi_bus_attach_private_data() to facilitate to attach data
> >      to ACPI handle
> >    ACPI/Thermal: Use acpi_bus_attach_private_data() to attach private
> >      data
> >    I2C/ACPI: Add i2c ACPI operation region support
> >    I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI config
> >
> >   drivers/acpi/acpica/rscreate.c |   1 +
> >   drivers/acpi/bus.c             |  28 +++-
> >   drivers/acpi/thermal.c         |  11 +-
> >   drivers/i2c/Kconfig            |  18 +-
> >   drivers/i2c/Makefile           |   5 +-
> >   drivers/i2c/i2c-acpi.c         | 362 +++++++++++++++++++++++++++++++++++++++++
> >   drivers/i2c/i2c-core.c         |  97 +----------
> >   include/acpi/acpi_bus.h        |   2 +
> >   include/linux/acpi.h           |  11 ++
> >   include/linux/i2c.h            |  12 ++
> >   10 files changed, 439 insertions(+), 108 deletions(-)
> >   create mode 100644 drivers/i2c/i2c-acpi.c
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
