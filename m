Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaLIIYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:24:32 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54930 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaLIIYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:24:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        arm@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        srv_heupstream@mediatek.com, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>,
        Olof Johansson <olof@lixom.net>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Subject: Re: [PATCH v3 1/8] soc: mediatek: Add PMIC wrapper for MT8135 and MT6397 SoC
Date: Tue, 09 Dec 2014 09:23:18 +0100
Message-ID: <2248330.M654Toyebg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418091337.5663.9.camel@mtksdaap41>
References: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com> <2751641.o51TuZRl88@wuerfel> <1418091337.5663.9.camel@mtksdaap41>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:V8bdBfzjvrGEk4k/cfVjEGD2Vutx7fbqV8e6v6tWaRD/u/a3G7u
 Y9ZISUceHrgsdxJLex+sb5ScaiHmQA+RN5cbC8BDkkOnk7FTtRKrNesKSQ5umx1rWhLIbvE
 /ofkoawZ+b25VawRqCe6YEX8CtBD0Qn98iGrYAZNP/gmrScGCctfMe3MjM0vgVSpCb6HHx/
 Va1N08Jjy5hmOI86NRJdQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2014 10:15:37 Flora Fu wrote:
> Hi, Arnd,
> 
> On Fri, 2014-12-05 at 11:13 +0100, Arnd Bergmann wrote:
> > On Friday 05 December 2014 12:07:52 Flora Fu wrote:
> > > Add PMIC wrapper of MT8135 to access MT6397 MFD.
> > > 
> > > Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> > > 
> > 
> > Please explain what a PMIC wrapper is and why you need one for MT8135.
> > I don't understand the purpose of this code at all. Is this just another
> > way of accessing the MT6397 when not using i2c or spi like other
> > PMIC drivers do?
> > 
> 
> Yes, MT8135 uses a proprietary hardware to communicate with MT6397. 
> The hardware is called PMIC Wrapper or PWRAP.
> Since it is not standard i2c or spi protocols, a soc related software
> driver is implemented to handle access protocols in AP side.
> 
> +-----------------+           +---------------+
> |                 |           |               |
> | Mediatek AP SoC |           |               |
> | (ex. MT8135)    |           |    MT6397     |
> |                 |           |               |
> |      +--------+ | (SPI bus) | +--------+    |
> |      |        | |-----------| |        |    |
> |      |  PMIC  | |-----------| |  PMIC  |    |
> |      | Wrapper| |-----------| | Wrapper|    |
> |      |        | |-----------| |        |    |
> |      +--------+ |           | +--------+    |
> |                 |           |               |
> +-----------------+           +---------------+
> 

I think we have had a similar case recently where a controller wasn't
actually using I2C, but the sofware protocol was close enough so we decided
to make it appear as i2c in Linux.

Would that work for you, i.e. register the pmic wrapper as a fake spi
master driver in drivers/spi/ and register the rtc/regulator/codec
as SPI clients from DT?

	Arnd
