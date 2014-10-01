Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbaJAIDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:03:55 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:58458 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaJAIDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:03:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 05/15] gpio / ACPI: Add support for _DSD device properties
Date: Wed, 01 Oct 2014 10:03:38 +0200
Message-ID: <5364540.jzXqjZX0yp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4786851.38d7sjpzag@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan> <4786851.38d7sjpzag@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:28kSczTeyL8I9WN+AUi2cN69+1l4LPHhRpVUk7EhnNT
 /5CoJqmINBqK3949E/craSzBHjpHQJMQacY88U9U8+V/oi10KW
 YJk9DVwN2Qx6nKWf2wFZ13YoUeoWA/Gk7vuaE+7G1YJwGFO0k0
 oBrdSc/zFoScS1JFOHiJoSkQv8zMmppxImLylK2zurDXQlh7OZ
 WiXzTbTfckjGZGpK34wrhjwcjGHOXPyWyCYOegwJpY/DHaujSn
 OEcqbRoAfThkbgYXA75Rlljr1Jqto9Ez7GMfGRt0G84oU4MSuY
 nKmbc2fdMM6N0MGdNiOnOgcTFlR/YygQ70SP4aiz1eHUJzYLnO
 selRl3iyJo5/zN+Zo/IQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 04:12:41 Rafael J. Wysocki wrote:
> +       static const char * const suffixes[] = { "gpios", "gpio" };
> +       struct acpi_device *adev = ACPI_COMPANION(dev);
>         struct acpi_gpio_info info;
>         struct gpio_desc *desc;
> +       char propname[32];
> +       int i;
>  
> -       desc = acpi_get_gpiod_by_index(dev, idx, &info);
> -       if (IS_ERR(desc))
> -               return desc;
> +       /* Try first from _DSD */
> +       for (i = 0; i < ARRAY_SIZE(suffixes); i++) {
> +               if (con_id && strcmp(con_id, "gpios")) {
> +                       snprintf(propname, sizeof(propname), "%s-%s",
> +                                con_id, suffixes[i]);
> +               } else {
> +                       snprintf(propname, sizeof(propname), "%s",
> +                                suffixes[i]);
> +               }

The general interface seems fine, but I'd be happier if you didn't
try to support all four of the possible syntaxes we have in DT.
It would be much better to have only "gpios" and not "gpio", and
the "foo-gpios" syntax should be replaced with whatever method you
use to name other subsystem specific links. For most subsystems
we now use something like "gpio-names", but unfortunately the GPIO
binding goes back to the time before we had come to that agreement.
The same applies to regulators.

This is ultimately up to the gpio maintainers though.

	Arnd
