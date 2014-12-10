Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaLJBH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:07:27 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:51874 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaLJBH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:07:26 -0500
MIME-Version: 1.0
In-Reply-To: <20141209214737.GO11764@sirena.org.uk>
References: <CAOMZO5DBL1G7H3RE43edi5ObGOzvF_2Oo+LHqiG7EFfoWjXxaA@mail.gmail.com>
	<CAOMZO5B0WcR-=__QzCzD86oocuj--uhq+QYj3o1WU05JO-Qyfw@mail.gmail.com>
	<20141209212708.GL11764@sirena.org.uk>
	<CAOMZO5DYuUmc9m65Pssmy+Ak+A__WTLmXY2=+3jQ1ZKQcE5Pew@mail.gmail.com>
	<20141209213728.GN11764@sirena.org.uk>
	<CAOMZO5C+gwVocek-6mvReyTbf4ZKAs2xDRmsT+pLqAQf1vVSCg@mail.gmail.com>
	<20141209214737.GO11764@sirena.org.uk>
Date: Tue, 9 Dec 2014 23:07:25 -0200
Message-ID: <CAOMZO5Dt-iBWurp9tCL=KROuRkGNpvD3oTvGjWL8RizrAp62wg@mail.gmail.com>
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

On Tue, Dec 9, 2014 at 7:47 PM, Mark Brown <broonie@kernel.org> wrote:

> My point is that I'm not seeing anything complaining about those devices
> or the supplies they offer so nothing there indicates to me that there's
> any kind of problem.

Yes, you are right. Sorry for the confusion here.

>> [    0.052239] CPU identified as i.MX6Q, silicon rev 1.2
>> [    0.072014] vdd1p1: 800 <--> 1375 mV at 1100 mV
>> [    0.073027] vdd3p0: 2800 <--> 3150 mV at 3000 mV
>> [    0.073933] vdd2p5: 2000 <--> 2750 mV at 2400 mV
>> [    0.074888] vddarm: 725 <--> 1450 mV at 1150 mV
>> [    0.075935] vddpu: 725 <--> 1450 mV at 1150 mV
>> [    0.076897] vddsoc: 725 <--> 1450 mV at 1200 mV
>
> Remember that these messages are now at debug level.

I was not aware of this change, thanks for letting me know.

Now I am back to the original da9052 regulator probe issue. If I do:

--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -554,7 +554,7 @@ int da9052_device_init(struct da9052 *da9052, u8 chip_id)
                return ret;
        }

-       ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
+       ret = mfd_add_devices(da9052->dev, 0, da9052_subdev_info,
                              ARRAY_SIZE(da9052_subdev_info), NULL, 0, NULL);

,then the da9052 regulator can probe succesfully:

ls /sys/class/regulator/
regulator.0   regulator.11  regulator.14  regulator.2   regulator.5
regulator.8
regulator.1   regulator.12  regulator.15  regulator.3   regulator.6
regulator.9
regulator.10  regulator.13  regulator.16  regulator.4   regulator.7

,except for this one:

[    0.157574] da9052-regulator da9052-regulator.14: invalid regulator
ID specified
[    0.157713] da9052-regulator: probe of da9052-regulator.14 failed
with error -2

Does anyone know why should I change the index of mfd_add_devices() ?

Thanks
