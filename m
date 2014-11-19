Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaKSRFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:05:06 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:51440 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbaKSRFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:05:03 -0500
Date: Wed, 19 Nov 2014 17:04:54 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Flora Fu <flora.fu@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Subject: Re: [PATCH 2/7] mfd: MT6397: Add regmap for MT8135 and MT6397 SoC
Message-ID: <20141119170454.GJ1875@x1>
References: <1416210027-5562-1-git-send-email-flora.fu@mediatek.com>
 <1416210027-5562-3-git-send-email-flora.fu@mediatek.com>
 <20141118114645.GX24004@x1>
 <20141118134618.GF30369@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141118134618.GF30369@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Sascha Hauer wrote:

> On Tue, Nov 18, 2014 at 11:46:45AM +0000, Lee Jones wrote:
> > On Mon, 17 Nov 2014, Flora Fu wrote:
> > 
> > > Add PMIC wrapper of MT8135 to access MFD MT6397.
> > > This is regmap of MT6397 MFD.
> > > 
> > > Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> > > ---
> > >  drivers/mfd/Kconfig            |   8 +
> > >  drivers/mfd/Makefile           |   1 +
> > >  drivers/mfd/mt8135-pmic-wrap.c | 847 +++++++++++++++++++++++++++++++++++++++++
> > 
> > All of the PMIC functionality needs removing from MFD and placed
> > somewhere else.  I suggest either drivers/power or drivers/regulator.
> 
> This is no PMIC functionality. The MT8135 has a unit which is is used to
> access the PMIC (which is not only a PMIC, but also Touchscreen
> interface and other stuff). This unit is called pmic-wrapper in the
> docs. See the introductory mail for a nice picture.

I saw the picture, it's very nice.  Whatever this is, it's not an
MFD.  It's a device which is located on an MFD.  There is far too much
functional (the operative word here) code contained in this patch.

I'm not sure where this device should live, but I'm keen for MFD not
to become a dumping ground for ill-fitting devices.  Happy for you to
create resources and register it from here, but the bulk for the
functional driver needs to live somewhere else. 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
