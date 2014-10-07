Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaJGLfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:35:37 -0400
Received: from mail-bn1on0090.outbound.protection.outlook.com ([157.56.110.90]:42336
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751266AbaJGLfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:35:36 -0400
Date: Tue, 7 Oct 2014 13:35:23 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?U8O2cmVuIEJyaW5rbQ==?= =?UTF-8?B?YW5u?= 
	<soren.brinkmann@xilinx.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [RFC] pinctrl driver for Zynq
References: <c2b9a1c1-d3b9-48c5-9c14-a4c3a95965fa@BN1AFFO11FD046.protection.gbl>
 <CACRpkdaZ2Yy7=CcOjnsQ0K7KYTN=wHaeZTDNxpvnf+axLLLJ_g@mail.gmail.com>
In-Reply-To: <CACRpkdaZ2Yy7=CcOjnsQ0K7KYTN=wHaeZTDNxpvnf+axLLLJ_g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21000.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <90d8a43bab8a4bbfa018b497ce2d6c4d@BY2FFO11FD002.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(189002)(199003)(23676002)(120916001)(76176999)(108616004)(50986999)(54356999)(102836001)(86362001)(85306004)(64126003)(21056001)(76482002)(95666004)(31966008)(6806004)(104016003)(65806001)(64706001)(106466001)(20776003)(47776003)(4396001)(83506001)(74316001)(50466002)(99396003)(65956001)(80022003)(46102003)(107046002)(87936001)(92566001)(44976005)(19580395003)(85852003)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB011;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB011;
X-Forefront-PRVS: 035748864E
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Soren will reply it I believe just some explanation from me.

>> diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
>> index 4cc9913078cd..1ae9bcaee252 100644
>> --- a/arch/arm/boot/dts/zynq-zc706.dts
>> +++ b/arch/arm/boot/dts/zynq-zc706.dts
>> @@ -33,11 +33,20 @@
>>  &gem0 {
> 
> I'm not familiar with this syntax of putting an ampersand in front
> of a node like that. What does that mean? To me ampersands
> are phandles :-/

It just uses node label as reference and add some properties to it.
It means gem0 node is in dtsi and in this dts we want to extend it
by board specific information.

...

>> +       pctrl = devm_kzalloc(&pdev->dev, sizeof(*pctrl), GFP_KERNEL);
>> +       if (!pctrl)
>> +               return -ENOMEM;
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +
>> +       slcr = of_get_parent(pdev->dev.of_node);
>> +       if (slcr->data) {
>> +               pctrl->regs = (__force void __iomem *)slcr->data + res->start;
> 
> This looks weird. Use DT parsing functions and accessors, no funny
> business like this. The res-start to the device should be the real
> physical address, not a relative base with offset, dunno what happened
> here but it is wrong.

Soren already has follow up version with is using regmap interface because slcr
is parent and it is syscon. That's why this code will go away.

Thanks,
Michal

