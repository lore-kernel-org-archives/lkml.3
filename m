Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3KVM2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:28:55 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62426 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752132Ab3KVM2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:28:53 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <cjb@laptop.org>, Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] gpio / ACPI: convert users to gpiod_* and drop acpi_gpio.h
Date: Fri, 22 Nov 2013 13:41:35 +0100
Message-ID: <9252491.gfcLFPm9bi@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 22, 2013 02:14:27 PM Mika Westerberg wrote:
> Hi all,
> 
> Now that the mainline kernel has full ACPI support for the GPIO descriptor
> interface we can get rid of ACPI specific GPIO functions in favor of GPIO
> descriptor (gpiod_*) interfaces.
> 
> This series first converts the existing two users to this interface and
> then modifies gpiolib and gpiolib-acpi so that the ACPI functions are only
> called internally in drivers/gpio. We then remove the acpi_gpio.h and
> require all users to user gpiod_* interfaces.
> 
> This is second version of the series. Changes to the previous [1]:
>  * paz00 is passing the lookup table so that we don't need to have gpio
>    conversion function in rfkill-gpio.c anymore.
>  * Corrected sdhci-acpi.c to pass con_id and added call to
>    gpiod_direction_input().
> 
> I suppose it would make sense to merge the whole series via GPIO or ACPI
> trees because there's a dependency that the first two patches need to be
> applied before last three. Otherwise the drivers in question fail to
> compile.
> 
> [1] https://lkml.org/lkml/2013/11/21/317
> 
> Heikki Krogerus (3):
>   net: rfkill: gpio: convert to descriptor-based GPIO interface
>   ARM: tegra: add gpiod_lookup table for paz00
>   net: rfkill: gpio: remove gpio conversion support
> 
> Mika Westerberg (4):
>   mmc: sdhci-acpi: covert to use GPIO descriptor API
>   gpio / ACPI: register to ACPI events automatically
>   gpio / ACPI: get rid of acpi_gpio.h
>   Documentation / ACPI: update to GPIO descriptor API
> 
>  Documentation/acpi/enumeration.txt | 36 ++++--------------
>  arch/arm/mach-tegra/board-paz00.c  |  9 ++++-
>  drivers/gpio/gpiolib-acpi.c        | 20 +++++++---
>  drivers/gpio/gpiolib.c             |  5 ++-
>  drivers/gpio/gpiolib.h             | 46 +++++++++++++++++++++++
>  drivers/mmc/host/sdhci-acpi.c      | 26 ++++++-------
>  drivers/pinctrl/pinctrl-baytrail.c |  4 --
>  include/linux/acpi_gpio.h          | 51 -------------------------
>  net/rfkill/rfkill-gpio.c           | 77 +++++++++++++++++---------------------
>  9 files changed, 125 insertions(+), 149 deletions(-)
>  create mode 100644 drivers/gpio/gpiolib.h
>  delete mode 100644 include/linux/acpi_gpio.h

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

for the ACPI-related material in this series.

Thanks,
Rafael

