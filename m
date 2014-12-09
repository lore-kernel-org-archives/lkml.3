Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaLIVkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:40:42 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:57449 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbaLIVkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:40:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141209213728.GN11764@sirena.org.uk>
References: <CAOMZO5DBL1G7H3RE43edi5ObGOzvF_2Oo+LHqiG7EFfoWjXxaA@mail.gmail.com>
	<CAOMZO5B0WcR-=__QzCzD86oocuj--uhq+QYj3o1WU05JO-Qyfw@mail.gmail.com>
	<20141209212708.GL11764@sirena.org.uk>
	<CAOMZO5DYuUmc9m65Pssmy+Ak+A__WTLmXY2=+3jQ1ZKQcE5Pew@mail.gmail.com>
	<20141209213728.GN11764@sirena.org.uk>
Date: Tue, 9 Dec 2014 19:40:40 -0200
Message-ID: <CAOMZO5C+gwVocek-6mvReyTbf4ZKAs2xDRmsT+pLqAQf1vVSCg@mail.gmail.com>
Subject: Re: da9052-regulator fails to probe in linux-next
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 7:37 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Dec 09, 2014 at 07:34:09PM -0200, Fabio Estevam wrote:
>
>> Yes, so here is a cleaner one:
>> http://arm-soc.lixom.net/bootlogs/next/next-20141104/wandboard-arm-imx_v6_v7_defconfig.html
>
>> The anatop regulators is drivers/regulator/pfuze100-regulator.c and
>> the dt description is at:
>> arch/arm/boot/dts/imx6qdl.dtsi
>
> Still not seeing any references to either pfuze100 or vdd (other than
> the external audio CODEC)...

Exactly, that's the bug :-)

If we compare it against next-20141031:
http://arm-soc.lixom.net/bootlogs/next/next-20141031/wandboard-arm-imx_v6_v7_defconfig.html

We get:

[    0.052239] CPU identified as i.MX6Q, silicon rev 1.2
[    0.072014] vdd1p1: 800 <--> 1375 mV at 1100 mV
[    0.073027] vdd3p0: 2800 <--> 3150 mV at 3000 mV
[    0.073933] vdd2p5: 2000 <--> 2750 mV at 2400 mV
[    0.074888] vddarm: 725 <--> 1450 mV at 1150 mV
[    0.075935] vddpu: 725 <--> 1450 mV at 1150 mV
[    0.076897] vddsoc: 725 <--> 1450 mV at 1200 mV
