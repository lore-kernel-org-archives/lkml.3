Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbaLICPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:15:43 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:33107 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755257AbaLICPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:15:41 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v3 1/8] soc: mediatek: Add PMIC wrapper for MT8135 and
 MT6397 SoC
From: Flora Fu <flora.fu@mediatek.com>
To: Arnd Bergmann <arnd@arndb.de>, Matthias Brugger <matthias.bgg@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        <arm@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <srv_heupstream@mediatek.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>,
        Olof Johansson <olof@lixom.net>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
In-Reply-To: <2751641.o51TuZRl88@wuerfel>
References: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com>
	 <1417752479-4749-2-git-send-email-flora.fu@mediatek.com>
	 <2751641.o51TuZRl88@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 9 Dec 2014 10:15:37 +0800
Message-ID: <1418091337.5663.9.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnd,

On Fri, 2014-12-05 at 11:13 +0100, Arnd Bergmann wrote:
> On Friday 05 December 2014 12:07:52 Flora Fu wrote:
> > Add PMIC wrapper of MT8135 to access MT6397 MFD.
> > 
> > Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> > 
> 
> Please explain what a PMIC wrapper is and why you need one for MT8135.
> I don't understand the purpose of this code at all. Is this just another
> way of accessing the MT6397 when not using i2c or spi like other
> PMIC drivers do?
> 

Yes, MT8135 uses a proprietary hardware to communicate with MT6397. 
The hardware is called PMIC Wrapper or PWRAP.
Since it is not standard i2c or spi protocols, a soc related software
driver is implemented to handle access protocols in AP side.

+-----------------+           +---------------+
|                 |           |               |
| Mediatek AP SoC |           |               |
| (ex. MT8135)    |           |    MT6397     |
|                 |           |               |
|      +--------+ | (SPI bus) | +--------+    |
|      |        | |-----------| |        |    |
|      |  PMIC  | |-----------| |  PMIC  |    |
|      | Wrapper| |-----------| | Wrapper|    |
|      |        | |-----------| |        |    |
|      +--------+ |           | +--------+    |
|                 |           |               |
+-----------------+           +---------------+

Thanks,
Flora


