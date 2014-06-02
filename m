Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaFBN3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:29:20 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:16301
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754521AbaFBN3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:29:18 -0400
Date: Mon, 2 Jun 2014 15:28:49 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>, Michal Simek <monstr@monstr.eu>
CC: Harini Katakam <harinik@xilinx.com>, "wim@iguana.be" <wim@iguana.be>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] watchdog: Add Cadence WDT driver
References: <1401185895-3677-1-git-send-email-harinik@xilinx.com>
 <20140529092106.GC24233@leverpostej> <53870129.5010505@monstr.eu>
 <20140529131940.GG24233@leverpostej> <538C18CC.6040105@monstr.eu>
 <20140602131704.GE13573@leverpostej>
In-Reply-To: <20140602131704.GE13573@leverpostej>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <a0938c62-2b96-447b-b8fb-a9b936b6ba00@BY2FFO11FD049.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(24454002)(51704005)(164054003)(199002)(189002)(377454003)(479174003)(87936001)(80022001)(21056001)(31696002)(50466002)(85852003)(86362001)(104016001)(76482001)(92726001)(79102001)(83506001)(102836001)(50986999)(54356999)(33646001)(76176999)(77096999)(83072002)(46102001)(31966008)(20776003)(74662001)(74316001)(99396002)(64126003)(4396001)(6806004)(83322001)(23756003)(77982001)(64706001)(65956001)(81542001)(92566001)(47776003)(44976005)(70736001)(74502001)(81342001)(65826006);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB028;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0230B09AC4
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 03:17 PM, Mark Rutland wrote:
> On Mon, Jun 02, 2014 at 07:25:16AM +0100, Michal Simek wrote:
>> On 05/29/2014 03:19 PM, Mark Rutland wrote:
>>> On Thu, May 29, 2014 at 10:43:05AM +0100, Michal Simek wrote:
>>>> Hi Mark,
>>>>
>>>>>> +static struct of_device_id cdns_wdt_of_match[] = {
>>>>>> +       { .compatible = "xlnx,zynq-wdt-r1p2", },
>>>>>> +       { .compatible = "cdns,wdt-r1p2", },
>>>>>
>>>>> If these can currently be handled identically, why not just have
>>>>> "cdns,wdt-r1p2" in the driver and in your dts have:
>>>>>
>>>>> compatible = "xlnx,zynq-wdt-r1p2", "cdns,wdt-r1p2";
>>>>>
>>>>> If we need to distinguish the two for some reason later we can always
>>>>> add the "xlnx,zynq-wdt-r1p2" string to the driver.
>>>>
>>>> I would prefer to have 2 compatible strings just because
>>>> of that we don't know what is different compare to origin cadence
>>>> version. We have done the same for spi-cadence.c that's why
>>>> it shouldn't be any problem to keep it as is.
>>>> Having zynq compatible property here and using it give us option
>>>> that if another SoC vendor come with new configuration or clean
>>>> cadence one we can simple handle it without changing compatible
>>>> property for us.
>>>
>>> Sure, we can have two documented strings. But as I mention for the
>>> moment the driver only needs to support the one string so long as a
>>> given dts has both. Then we can later distinguish the zynq variant (or
>>> any other) as necessary.
>>
>> ok then. Let's use just "xlnx,zynq-wdt-r1p2" compatible string here
>> and remove "cdns,wdt-r1p2"
> 
> That if anything seems backwards -- the driver should jsut take the most
> general string for now: "cdns,wdt-r1p2", while the dtb will have both:
> 
> compatible = "xlnx,zynq-wdt-r1p2", "cdns,wdt-r1p2";
> 
> The driver can later disintguish "xlnx,zynq-wdt-r1p2" specially if
> necessary.

ah. Ok I see your point now. No problem to do it in this way.

Thanks,
Michal



