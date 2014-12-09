Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaLIVR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:17:29 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50418 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaLIVRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:17:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DBL1G7H3RE43edi5ObGOzvF_2Oo+LHqiG7EFfoWjXxaA@mail.gmail.com>
References: <CAOMZO5DBL1G7H3RE43edi5ObGOzvF_2Oo+LHqiG7EFfoWjXxaA@mail.gmail.com>
Date: Tue, 9 Dec 2014 19:17:14 -0200
Message-ID: <CAOMZO5B0WcR-=__QzCzD86oocuj--uhq+QYj3o1WU05JO-Qyfw@mail.gmail.com>
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

On Tue, Dec 9, 2014 at 6:41 PM, Fabio Estevam <festevam@gmail.com> wrote:
> Hi,
>
> In linux-next I am no longer able to get da9052 regulator driver
> probed on a imx53-qsb board:
>
> [    0.128665] da9052-regulator da9052-regulator: invalid regulator ID specified
> [    0.128786] da9052-regulator: probe of da9052-regulator failed with error -22
> [    0.128957] ------------[ cut here ]------------
> [    0.129010] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:31
> sysfs_warn_dup+0x5c/0x7c()
> [    0.129043] sysfs: cannot create duplicate filename
> '/devices/platform/soc/60000000.aips/63fc8000.i2c/i2c-0/0-0048/da9052-regulator
> '
> .....
>
> With kernel 3.18 it probes fine. Haven't bisected yet, but if anyone
> has any ideas, please let me know.

Seem like this issue is not specific to the da9052 regulator.

On a imx6q-wandboard we can see the internal anatop regulators being
probed on linux-next 20141031:
http://arm-soc.lixom.net/bootlogs/next/next-20141031/wandboard-arm-imx_v6_v7_defconfig.html

[    0.072014] vdd1p1: 800 <--> 1375 mV at 1100 mV
[    0.073027] vdd3p0: 2800 <--> 3150 mV at 3000 mV
[    0.073933] vdd2p5: 2000 <--> 2750 mV at 2400 mV
[    0.074888] vddarm: 725 <--> 1450 mV at 1150 mV
[    0.075935] vddpu: 725 <--> 1450 mV at 1150 mV
[    0.076897] vddsoc: 725 <--> 1450 mV at 1200 mV


,but since next-20141103 they do not probe anymore:
http://arm-soc.lixom.net/bootlogs/next/next-20141103/wandboard-arm-imx_v6_v7_defconfig.html
