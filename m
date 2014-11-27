Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaK0N5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:57:30 -0500
Received: from mail-bn1on0068.outbound.protection.outlook.com ([157.56.110.68]:31526
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750780AbaK0N52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:57:28 -0500
Date: Thu, 27 Nov 2014 14:57:13 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <monstr@monstr.eu>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        Sandeep Nair <sandeep_n@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@gmail.com>,
        Andy Gross <agross@codeaurora.org>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] ARM: zynq: Add OCM controller driver
References: <cover.1415962281.git.michal.simek@xilinx.com>
	<6741d995fbec801d795c5db481e39425bd912f8a.1415962281.git.michal.simek@xilinx.com>
 <CACRpkdbZ8Pwy=04dhJq5ONZ1B-SQK1f=eLZjjCDmV7UQ0aHduA@mail.gmail.com>
In-Reply-To: <CACRpkdbZ8Pwy=04dhJq5ONZ1B-SQK1f=eLZjjCDmV7UQ0aHduA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21132.007
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <857cab03bd6445c59cc345349a00f67c@BL2FFO11FD010.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(189002)(51704005)(479174003)(377454003)(199003)(4396001)(108616004)(54356999)(44976005)(83506001)(107046002)(19580395003)(74316001)(77156002)(87936001)(20776003)(65806001)(104016003)(21056001)(64706001)(92566001)(6806004)(102836001)(76176999)(99396003)(86362001)(50466002)(95666004)(50986999)(64126003)(62966003)(120916001)(46102003)(19580405001)(106466001)(47776003)(23676002)(31966008)(65956001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB052;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB052;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB052;
X-Forefront-PRVS: 040866B734
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB052;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 02:20 PM, Linus Walleij wrote:
> On Fri, Nov 14, 2014 at 11:52 AM, Michal Simek <michal.simek@xilinx.com> wrote:
> 
>> The driver provide memory allocator which can
>> be used by others drivers to allocate memory inside OCM.
>> All location for 64kB blocks are supported
> 
> Allocation?
> 
>> and driver is trying to allocate the largest continuous
>> block of memory.
> 
> Isn't all genalloc allocations continuous?

I hope it is but blocks can be at different locations.

Two locations 0 or 0xfffc0000.
it means for every 64k block can be at low or high address location
first block 0x0 or 0xfffc0000
second block 0x10000 or 0xfffd0000
third block 0x20000 or 0xfffe0000
four block 0x30000 or 0xffff0000

it is worth to allocate to biggest continuous memory.
For example 2 blocks low and then 2 blocks high.

2 blocks with 128kB is better then 4 blocks with 64kB

> 
> (...)
>> +       zynq_ocmc->pool = devm_gen_pool_create(&pdev->dev,
>> +                                              ilog2(ZYNQ_OCMC_GRANULARITY),
>> +                                              -1);
> 
> Do this:
> 
> #include <linux/sizes.h>
> 
> zynq_ocmc->pool = devm_gen_pool_create(&pdev->dev,
>                                        ilog2(SZ_64K),
>                                        -1);
> 
> And get rid of the #define for ZYNQ_OCMC_GRANULARITY

ilog2 from 32 is different to ilog2 from ilog2 from 0x10000.
But I will look at gen pool internals.

Do you have any opinion regarding calling zynq_slcr_get_ocm_config()?

Is it better to expose slcr this interface to drivers?
Or use regmap and read this value directly?

Also I do read for CONFIG_SMP case jump trampoline size - maybe
you can have better idea how this can be done.

Thanks for your input,
Michal

