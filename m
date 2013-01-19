Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3ASALn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:11:43 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:46132 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab3ASALm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:11:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 0/3] x86: enable common clk and add support for Lynxpoint clocks
Date: Sat, 19 Jan 2013 01:17:36 +0100
Message-ID: <2132297.E3RA4GlFZ9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358516761-20981-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358516761-20981-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 18, 2013 03:45:58 PM Mika Westerberg wrote:
> This is second iteration of the series. First revision is available here:
> 
> 	https://lkml.org/lkml/2013/1/14/213
> 
> Idea is to let the LPSS peripheral drivers to use common clk framework to
> get clock rate or enable/disable the functional clock. The discussion
> started in this thread:
> 
> 	http://thread.gmane.org/gmane.linux.kernel/1417691
> 
> In summary, there is no point in adding a special case code to the drivers
> in order to pass them a fixed clock rate, but instead x86 should just
> enable common clk subsystem and take advantage of it.
> 
> We try to address that in this series. Instead of enabling the common clk
> framework by default we place it under CONFIG_X86_INTEL_LPSS config option.
> This option then selects what is necessary to support the LPSS peripheral
> drivers.
> 
> We then create the Lynxpoint clock tree and populate it accordingly.
> 
> Changes to previous version:
> 	- add config option CONFIG_X86_INTEL_LPSS
> 	- pass flags to acpi_create_platform_device() instead of calling
> 	  function in drivers/acpi/scan.c
> 	- create the clock platform devices in drivers/acpi/acpi_platform.c
> 
> Please review.
> 
> Mika Westerberg (3):
>   x86: add support for Intel Low Power Subsystem
>   clk: x86: add support for Lynxpoint LPSS clocks
>   ACPI / platform: create LPSS clocks if Lynxpoint devices are found
>     during scan
> 
>  arch/x86/Kconfig             |   10 +++++
>  drivers/acpi/acpi_platform.c |   25 ++++++++++-
>  drivers/acpi/internal.h      |    6 ++-
>  drivers/acpi/scan.c          |   22 +++++-----
>  drivers/clk/Makefile         |    1 +
>  drivers/clk/x86/Makefile     |    2 +
>  drivers/clk/x86/clk-lpss.c   |   99 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/x86/clk-lpss.h   |   36 +++++++++++++++
>  drivers/clk/x86/clk-lpt.c    |   86 ++++++++++++++++++++++++++++++++++++
>  9 files changed, 275 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/clk/x86/Makefile
>  create mode 100644 drivers/clk/x86/clk-lpss.c
>  create mode 100644 drivers/clk/x86/clk-lpss.h
>  create mode 100644 drivers/clk/x86/clk-lpt.c

This version looks OK to me, so if there are no objections, I'm going to
apply it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
