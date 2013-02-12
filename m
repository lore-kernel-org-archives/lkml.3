Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3BLGU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 01:20:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50152 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab3BLGUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 01:20:55 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "hs@denx.de" <hs@denx.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] ARM: davinci: da850: override mmc DT node device
 name
Thread-Topic: [PATCH v2 1/3] ARM: davinci: da850: override mmc DT node
 device name
Thread-Index: AQHOBQiQ2hb8OBRcOkKUp3TI3H3nbJh1Yk2AgABlC/A=
Date: Tue, 12 Feb 2013 06:20:24 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3EA4685E@DBDE01.ent.ti.com>
References: <1360223825-23929-1-git-send-email-prakash.pm@ti.com>
 <1360223825-23929-2-git-send-email-prakash.pm@ti.com>
 <5119D72D.3010605@ti.com>
In-Reply-To: <5119D72D.3010605@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1C6Kvcl020608

On Tue, Feb 12, 2013 at 11:16:21, Nori, Sekhar wrote:
> On 2/7/2013 1:27 PM, Manjunathappa, Prakash wrote:
> > Populate OF_DEV_AUXDATA with desired device name expected by
> > davinci_mmc driver. Without this clk_get of davinci_mmc DT driver
> > fails.
> 
> But there is no mmc DT support for DaVinci at this time. This patch
> should come after the driver DT support and .dts addition patches.
> 

Agreed, I will bring it up in the series.

> > diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
> > index 37c27af..3362ca4 100644
> > --- a/arch/arm/mach-davinci/da8xx-dt.c
> > +++ b/arch/arm/mach-davinci/da8xx-dt.c
> > @@ -39,9 +39,16 @@ static void __init da8xx_init_irq(void)
> >  
> >  #ifdef CONFIG_ARCH_DAVINCI_DA850
> >  
> > +static const struct of_dev_auxdata da8xx_auxdata[] __initconst = {
> > +	OF_DEV_AUXDATA("ti,davinci-mmc-da830", 0x01c40000, "davinci_mmc.0",
> > +			NULL),
> > +	{},
> > +};
> > +
> >  static void __init da850_init_machine(void)
> >  {
> > -	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> > +	of_platform_populate(NULL, of_default_bus_match_table, da8xx_auxdata,
> > +			NULL);
> 
> This needs to be rebased on by v3.9/dt-2 branch. There are conflicts
> with the code already present.
> 

Yes, I will send it after rebasing on new branch.

Thanks,
Prakash

> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
