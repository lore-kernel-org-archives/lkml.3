Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbaLILUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:20:52 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:51608 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbaLILUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:20:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Flora Fu <flora.fu@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, arm@kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>,
        Olof Johansson <olof@lixom.net>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Subject: Re: [PATCH v3 1/8] soc: mediatek: Add PMIC wrapper for MT8135 and MT6397 SoC
Date: Tue, 09 Dec 2014 12:20:04 +0100
Message-ID: <3015972.tvmzP0zTdv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CABuKBe+whgVryssULCu2MAXRu3u+pYwM2nN3ToTEGpEvniQ6Jw@mail.gmail.com>
References: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com> <20141209101341.GV30369@pengutronix.de> <CABuKBe+whgVryssULCu2MAXRu3u+pYwM2nN3ToTEGpEvniQ6Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Gl3qAiQYY4me2G3PIJZD3noR4LoyLIAVqgoAcvi5hwR0ujWrF4W
 L29EnaYVt53bTOhCGO+Tn3t4kav2w/+McYXgDzzTGpIIs/rZCk+RuJMsfXuMsmhd6bU5VZF
 Rki6eUAdyfoMD9/w6xHOAMZQmXU/mToc9yTo9C1HcUpkhJez7A65VrelZZl1cNsUK/Vquew
 RBNLp0hukBVc1ymErVSUg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2014 11:30:15 Matthias Brugger wrote:
> 2014-12-09 11:13 GMT+01:00 Sascha Hauer <s.hauer@pengutronix.de>:
> > On Tue, Dec 09, 2014 at 09:23:18AM +0100, Arnd Bergmann wrote:
> >>
> >> I think we have had a similar case recently where a controller wasn't
> >> actually using I2C, but the sofware protocol was close enough so we decided
> >> to make it appear as i2c in Linux.
> >>
> >> Would that work for you, i.e. register the pmic wrapper as a fake spi
> >> master driver in drivers/spi/ and register the rtc/regulator/codec
> >> as SPI clients from DT?
> >
> > I don't think that's appropriate. I mean technically that could even
> > work, but in software you really don't see anything from the underlying
> > SPI bus. The SoC and the PMIC are really tightly coupled via the PMIC
> > wrapper. This goes to the point where pins of the SoCs internal I2C and
> > keypad controllers are routed over the SPI bus out of the PMIC. In
> > software you do this by setting a bit in the I2C controller. If it's
> > set, the signals are routed out of the PMIC instead of the main die.
> > As said, technically we probably could create a fake SPI master, but
> > that wouldn't really fit to this situation.

Ok, I see.

> I agree with Sascha. Although from the hardware point of view, the
> communication between the PMIC and the SOC is done through SPI from
> the point of view of the software everything looks like I2C commands
> which will be "transalted" into SPI messages by the PMIC wrapper.

If it looks like i2c messages, would it be more appropriate to make
it appear as an i2c controller then?

	Arnd
