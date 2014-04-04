Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaDDBOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 21:14:45 -0400
Received: from [207.46.163.237] ([207.46.163.237]:6002 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751215AbaDDBOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 21:14:40 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: "wim@iguana.be" <wim@iguana.be>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv4 2/2] watchdog: imx2_wdt: convert to use regmap API.
Thread-Topic: [PATCHv4 2/2] watchdog: imx2_wdt: convert to use regmap API.
Thread-Index: AQHPTt69R9PCJUUK7UW+0eH2KtDmx5sAF94AgACOdvA=
Date: Fri, 4 Apr 2014 01:13:37 +0000
Message-ID: <6563b26412a7457ba38e2dcf0bdcb643@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396487059-15298-1-git-send-email-Li.Xiubo@freescale.com>
 <1396487059-15298-3-git-send-email-Li.Xiubo@freescale.com>
 <20140403163604.GA11832@roeck-us.net>
In-Reply-To: <20140403163604.GA11832@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(77982001)(59766001)(4396001)(31966008)(33646001)(80976001)(74662001)(94946001)(53806001)(98676001)(81542001)(74366001)(63696002)(83072002)(74502001)(81686001)(47736001)(79102001)(50986001)(47446002)(47976001)(2656002)(92566001)(99396002)(90146001)(56816005)(80022001)(85306002)(66066001)(93516002)(76796001)(49866001)(95416001)(93136001)(95666003)(46102001)(76576001)(69226001)(65816001)(85852003)(20776003)(97186001)(54356001)(51856001)(86362001)(99286001)(97336001)(87266001)(87936001)(54316002)(56776001)(74876001)(74316001)(81342001)(81816001)(94316002)(74706001)(83322001)(19580395003)(76482001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:8B7EE02E.61257D9.B8488370.82A28E18.2022B;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	base = devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(base))
> > +		return PTR_ERR(base);
> > +
> > +	imx2_wdt.regmap = devm_regmap_init_mmio_clk(&pdev->dev, NULL, base,
> > +						    &imx2_wdt_regmap_config);
> 
> This patch causes the following buiild failure:
> 
> Building arm:imx_v4_v5_defconfig ... failed
> --------------
> Error log:
> drivers/built-in.o: In function `imx2_wdt_probe':
> clk-composite.c:(.init.text+0x82c4): undefined reference to
> `devm_regmap_init_mmio_clk'
> make: *** [vmlinux] Error 1
> --------------
> 
> This is on top of
> 
> b33ce44 Merge branch 'for-3.15/drivers' of git://git.kernel.dk/linux-block
> 
> Does it have build dependencies on code which is (or was) not yet available
> in mainline ?
> 

This is caused by not compiling the regmap core.

Could you add the following patch to have a try ?
==========================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 79d2589..3e55fa9 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -369,6 +369,7 @@ config MAX63XX_WATCHDOG
 config IMX2_WDT
        tristate "IMX2+ Watchdog"
        depends on ARCH_MXC
+       select REGMAP_MMIO
        help
          This is the driver for the hardware watchdog
          on the Freescale IMX2 and later processors.
--------------------------

If it's okey, I'll sent the v5 series to fix this.

Thanks very much,

BRs
Xiubo


