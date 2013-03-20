Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab3CTLa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:30:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38943 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab3CTLaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:30:23 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: RE: [PATCH v2 2/3] arm: davinci: clock node support for ECAP &
 EHRPWM
Thread-Topic: [PATCH v2 2/3] arm: davinci: clock node support for ECAP &
 EHRPWM
Thread-Index: AQHOJTXwqHwM5K37E0yuf3UM2IS8rJiuFF8AgABdGtA=
Date: Wed, 20 Mar 2013 11:29:14 +0000
Deferred-Delivery: Wed, 20 Mar 2013 11:29:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA99E05@DBDE01.ent.ti.com>
References: <1363761714-15034-1-git-send-email-avinashphilip@ti.com>
 <1363761714-15034-3-git-send-email-avinashphilip@ti.com>
 <51499C72.9030602@ti.com>
In-Reply-To: <51499C72.9030602@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2KBUVGZ031685

On Wed, Mar 20, 2013 at 16:54:34, Nori, Sekhar wrote:
> On 3/20/2013 12:11 PM, Philip Avinash wrote:
> > Add clock node support for ECAP and EHRPWM modules.
> > Also adds TBCLK for EHRWPM TBCLK to comply with pwm-tiehrpwm
> > driver.
> > 
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> > ---
> > Changes Since v1:
> > 	- TBCLK make it as actual clock with enable/disable feature.
> > 
> > :100644 100644 0c4a26d... dbed75c... M	arch/arm/mach-davinci/da850.c
> > :100644 100644 de439b7... be77ce2... M	arch/arm/mach-davinci/include/mach/da8xx.h
> >  arch/arm/mach-davinci/da850.c              |   46 ++++++++++++++++++++++++++++
> >  arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
> >  2 files changed, 47 insertions(+)
> > 
> > diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
> > index 0c4a26d..dbed75c 100644
> > --- a/arch/arm/mach-davinci/da850.c
> > +++ b/arch/arm/mach-davinci/da850.c
> > @@ -383,6 +383,49 @@ static struct clk dsp_clk = {
> >  	.flags		= PSC_LRST | PSC_FORCE,
> >  };
> >  
> > +static struct clk ehrpwm_clk = {
> > +	.name		= "ehrpwm",
> > +	.parent		= &pll0_sysclk2,
> > +	.lpsc		= DA8XX_LPSC1_PWM,
> > +	.gpsc		= 1,
> > +	.flags		= DA850_CLK_ASYNC3,
> > +};
> > +
> > +#define DA8XX_EHRPWM_TBCLKSYNC	BIT(12)
> > +
> > +void tblck_enable(struct clk *clk)
> 
> This should be static. Also, since tbclk is associated with ehrpwm,
> please call the function ehrpwm_tbclk_enable().

Ok I will correct it.

Thanks
Avinash
> 
> > +{
> > +	u32 val;
> > +
> > +	val = readl(DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP1_REG));
> > +	val |= DA8XX_EHRPWM_TBCLKSYNC;
> > +	writel(val, DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP1_REG));
> > +}
> > +
> > +void tblck_disable(struct clk *clk)
> 
> Same comment as above applies.
> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
