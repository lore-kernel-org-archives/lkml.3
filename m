Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaLJBTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:19:17 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59963 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaLJBTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:19:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMZO5Dt-iBWurp9tCL=KROuRkGNpvD3oTvGjWL8RizrAp62wg@mail.gmail.com>
References: <CAOMZO5DBL1G7H3RE43edi5ObGOzvF_2Oo+LHqiG7EFfoWjXxaA@mail.gmail.com>
	<CAOMZO5B0WcR-=__QzCzD86oocuj--uhq+QYj3o1WU05JO-Qyfw@mail.gmail.com>
	<20141209212708.GL11764@sirena.org.uk>
	<CAOMZO5DYuUmc9m65Pssmy+Ak+A__WTLmXY2=+3jQ1ZKQcE5Pew@mail.gmail.com>
	<20141209213728.GN11764@sirena.org.uk>
	<CAOMZO5C+gwVocek-6mvReyTbf4ZKAs2xDRmsT+pLqAQf1vVSCg@mail.gmail.com>
	<20141209214737.GO11764@sirena.org.uk>
	<CAOMZO5Dt-iBWurp9tCL=KROuRkGNpvD3oTvGjWL8RizrAp62wg@mail.gmail.com>
Date: Tue, 9 Dec 2014 23:19:14 -0200
Message-ID: <CAOMZO5BoqKkS5nZij25T=Oofn-aiEZj0+vLibOou-zrccHac8g@mail.gmail.com>
Subject: Re: da9052-regulator fails to probe in linux-next
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 11:07 PM, Fabio Estevam <festevam@gmail.com> wrote:

> Now I am back to the original da9052 regulator probe issue. If I do:
>
> --- a/drivers/mfd/da9052-core.c
> +++ b/drivers/mfd/da9052-core.c
> @@ -554,7 +554,7 @@ int da9052_device_init(struct da9052 *da9052, u8 chip_id)
>                 return ret;
>         }
>
> -       ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
> +       ret = mfd_add_devices(da9052->dev, 0, da9052_subdev_info,
>                               ARRAY_SIZE(da9052_subdev_info), NULL, 0, NULL);
>
> ,then the da9052 regulator can probe succesfully:
>
> ls /sys/class/regulator/
> regulator.0   regulator.11  regulator.14  regulator.2   regulator.5
> regulator.8
> regulator.1   regulator.12  regulator.15  regulator.3   regulator.6
> regulator.9
> regulator.10  regulator.13  regulator.16  regulator.4   regulator.7
>
> ,except for this one:
>
> [    0.157574] da9052-regulator da9052-regulator.14: invalid regulator
> ID specified
> [    0.157713] da9052-regulator: probe of da9052-regulator.14 failed
> with error -2

Ok, if I do the same fix as in commit b668422872 ("mfd: viperboard:
Fix platform-device id collision)

--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -554,7 +554,7 @@ int da9052_device_init(struct da9052 *da9052, u8 chip_id)
                return ret;
        }

-       ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
+       ret = mfd_add_devices(da9052->dev, PLATFORM_DEVID_AUTO,
da9052_subdev_info,

Then I don't get any more da9052 warnings.

Will submit a patch shortly.
