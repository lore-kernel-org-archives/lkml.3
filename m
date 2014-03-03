Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaCCUJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:09:34 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.109]:25421 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754255AbaCCUJc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:09:32 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-3.tower-193.messagelabs.com!1393877369!15932678!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 03 Mar 2014 21:09:30 +0100
From: "Thumshirn, Johannes Tobias" <Johannes.Thumshirn@men.de>
To: Olof Johansson <olof@lixom.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/3] drivers: Introduce MEN Chameleon Bus
Thread-Topic: [PATCH v3 1/3] drivers: Introduce MEN Chameleon Bus
Thread-Index: AQHPMw/qr9ine4LXsEWzi9b5F2MWMprPtMmAgAAa9BU=
Date: Mon, 3 Mar 2014 20:09:28 +0000
Message-ID: <42A09AAC7DAAF64ABE4E4C1AD5F5E295475D66E7@MEN-EX1.intra.men.de>
References: <1393432147-31355-1-git-send-email-johannes.thumshirn@men.de>
	<1393432147-31355-2-git-send-email-johannes.thumshirn@men.de>,<CAOesGMjmdfRWddG+NWBg29mPik_s21fMQerCqUbEWUz8vP3KfQ@mail.gmail.com>
In-Reply-To: <CAOesGMjmdfRWddG+NWBg29mPik_s21fMQerCqUbEWUz8vP3KfQ@mail.gmail.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.1.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Olof Johansson [olof@lixom.net]
Sent: Monday, March 03, 2014 8:21 PM
To: Thumshirn, Johannes Tobias
Cc: Greg Kroah-Hartman; Jonathan Cameron; linux-iio@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] drivers: Introduce MEN Chameleon Bus

On Wed, Feb 26, 2014 at 8:29 AM, Johannes Thumshirn
<johannes.thumshirn@men.de> wrote:
> The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
> FPGA based devices. It is used to identify MCB based IP-Cores within
> an FPGA and provide the necessary framework for instantiating drivers
> for these devices.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
>  MAINTAINERS                     |   6 +
>  drivers/Kconfig                 |   2 +
>  drivers/Makefile                |   1 +
>  drivers/mcb/Kconfig             |  15 ++
>  drivers/mcb/Makefile            |   5 +
>  drivers/mcb/mcb-core.c          | 414 ++++++++++++++++++++++++++++++++++++++++
>  drivers/mcb/mcb-internal.h      | 116 +++++++++++
>  drivers/mcb/mcb-parse.c         | 159 +++++++++++++++
>  include/linux/mcb.h             | 119 ++++++++++++
>  include/linux/mod_devicetable.h |   5 +
>  10 files changed, 842 insertions(+)
>  create mode 100644 drivers/mcb/Kconfig
>  create mode 100644 drivers/mcb/Makefile
>  create mode 100644 drivers/mcb/mcb-core.c
>  create mode 100644 drivers/mcb/mcb-internal.h
>  create mode 100644 drivers/mcb/mcb-parse.c
>  create mode 100644 include/linux/mcb.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 85b3dd8..5d35f6c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5667,6 +5667,12 @@ L:       linux-watchdog@vger.kernel.org
>  S:     Supported
>  F:     drivers/watchdog/mena21_wdt.c
>
> +MEN CHAMELEON BUS (mcb)
> +M:     Johannes Thumshirn <johannes.thumshirn@men.de>
> +S:     Supported
> +F:     drivers/mcb/
> +F:     include/linux/mcb.h
> +
>  METAG ARCHITECTURE
>  M:     James Hogan <james.hogan@imgtec.com>
>  L:     linux-metag@vger.kernel.org
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index b3138fb..df2ac52 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -170,4 +170,6 @@ source "drivers/phy/Kconfig"
>
>  source "drivers/powercap/Kconfig"
>
> +source "drivers/mcb/Kconfig"
> +
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 8e3b8b0..c5bf50c 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -155,3 +155,4 @@ obj-$(CONFIG_IPACK_BUS)             += ipack/
>  obj-$(CONFIG_NTB)              += ntb/
>  obj-$(CONFIG_FMC)              += fmc/
>  obj-$(CONFIG_POWERCAP)         += powercap/
> +obj-$(CONFIG_MCB)              += mcb/

No single-driver directories like these. This needs to go somewhere else.

There are two drivers in this directory, so I guess it's O.K, isn't it?

> diff --git a/drivers/mcb/Kconfig b/drivers/mcb/Kconfig
> new file mode 100644
> index 0000000..44c82d6
> --- /dev/null
> +++ b/drivers/mcb/Kconfig
> @@ -0,0 +1,15 @@
> +#
> +# MEN Chameleon Bus (MCB) support
> +#
> +
> +menuconfig MCB
> +          tristate "MCB support"
> +          default m

Don't default to 'm' for new drivers. Just leave out the default (so
it will default to 'n').

 OK

> +          help
> +
> +          The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
> +          FPGA based devices. It is used to identify MCB based IP-Cores within
> +          an FPGA and provide the necessary framework for instantiating drivers
> +          for these devices.
> +
> +          If build as a module, the module is called mcb.ko


Not reviewing the rest of the driver, came across the patch due to
causing build breakage on last night's next ebsa110_defconfig for ARM:

drivers/mcb/mcb-parse.c:105:2: error: implicit declaration of function
'memcpy_fromio' [-Werror=implicit-function-declaration]


Yes I saw it as well. Currently taking care of it.

Johannes