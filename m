Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbaH0CTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:19:30 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:40448
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755194AbaH0CT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:19:29 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
 CLK_OF_DECLARE support
Thread-Topic: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
 CLK_OF_DECLARE support
Thread-Index: AQHPvfNVs2TWqmkiQk6JTABVnWcu25vjhIaAgAAsoIA=
Date: Wed, 27 Aug 2014 02:19:10 +0000
Message-ID: <164af7b3be3747a0be3fe3a6cf83d3b1@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1408700096-25415-1-git-send-email-jingchang.lu@freescale.com>
 <1409093463.6510.92.camel@snotra.buserror.net>
In-Reply-To: <1409093463.6510.92.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(51704005)(24454002)(13464003)(377424004)(189002)(199003)(54356999)(81542001)(105586002)(2656002)(20776003)(106356001)(50986999)(106116001)(74316001)(99286002)(95666004)(108616004)(64706001)(76176999)(110136001)(21056001)(77982001)(76576001)(101416001)(81342001)(107046002)(85306004)(79102001)(87936001)(33646002)(99396002)(80022001)(90102001)(46102001)(86362001)(19580405001)(92566001)(19580395003)(31966008)(74662001)(85852003)(76482001)(66066001)(83322001)(83072002)(74502001)(4396001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0728;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7R2JoRn006585

>-----Original Message-----
>From: Wood Scott-B07421
>Sent: Wednesday, August 27, 2014 6:51 AM
>To: Lu Jingchang-B35083
>Cc: mturquette@linaro.org; linuxppc-dev@lists.ozlabs.org; linux-
>kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
>CLK_OF_DECLARE support
>
>On Fri, 2014-08-22 at 17:34 +0800, Jingchang Lu wrote:
>> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
>> ---
>>  drivers/clk/Kconfig           | 7 ++++---
>>  drivers/clk/clk-ppc-corenet.c | 5 +++++
>>  2 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>> index cfd3af7..8784704 100644
>> --- a/drivers/clk/Kconfig
>> +++ b/drivers/clk/Kconfig
>> @@ -82,11 +82,12 @@ config COMMON_CLK_AXI_CLKGEN
>>  	  FPGAs. It is commonly used in Analog Devices' reference designs.
>>
>>  config CLK_PPC_CORENET
>> -	bool "Clock driver for PowerPC corenet platforms"
>> -	depends on PPC_E500MC && OF
>> +	bool "Clock driver for PowerPC corenet and compatible ARM-based
>platforms"
>> +	depends on (PPC_E500MC || ARM) && OF
>
>Should the symbol and driver be renamed to something like CLK_FSL_QORIQ?
>
This name is better for sharing on ARM and PowerPC, I will rename them. Thanks.

>> diff --git a/drivers/clk/clk-ppc-corenet.c b/drivers/clk/clk-ppc-
>corenet.c
>> index 8e58edf..7692cac 100644
>> --- a/drivers/clk/clk-ppc-corenet.c
>> +++ b/drivers/clk/clk-ppc-corenet.c
>> @@ -305,3 +305,8 @@ static int __init ppc_corenet_clk_init(void)
>>  	return platform_driver_register(&ppc_corenet_clk_driver);
>>  }
>>  subsys_initcall(ppc_corenet_clk_init);
>> +
>> +CLK_OF_DECLARE(ppc_core_pll_v1, "fsl,qoriq-core-pll-1.0",
>core_pll_init);
>> +CLK_OF_DECLARE(ppc_core_pll_v2, "fsl,qoriq-core-pll-2.0",
>core_pll_init);
>> +CLK_OF_DECLARE(ppc_core_mux_v1, "fsl,qoriq-core-mux-1.0",
>core_mux_init);
>> +CLK_OF_DECLARE(ppc_core_mux_v2, "fsl,qoriq-core-mux-2.0",
>core_mux_init);
>
>What does this do that the existing platform driver and match table
>don't?  Why is it needed for ARM when PPC didn't need it?
>
>-Scott
>
Common clk init on ARM platform is initialized earlier via of_clk_init() instead of
driver probe method, the of_clk_init will walk a __clk_of_table to init each clk provider
in the table, the CLK_OF_DECLARE() macro puts a supported clk in the __clk_of_table for
it initializing on starup, and the clk system has added some common clk such as "fixed-clk"
to this table already.
So here I add our specific clk init declaration to consist this framework, and the driver
probe function will not be needed on ARM.



Best Regards,
Jingchang



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
