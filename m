Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaEOKeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:34:37 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:16281
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750916AbaEOKef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:34:35 -0400
Date: Thu, 15 May 2014 12:33:53 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bart Tanghe <bart.tanghe@thomasmore.be>, Arnd Bergmann <arnd@arndb.de>
CC: <thierry.reding@gmail.com>, <michal.simek@xilinx.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <grant.likely@linaro.org>,
        <linux-pwm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [rfc]pwm: add xilinx pwm driver
References: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be>
 <4262573.aEBTd7FzV5@wuerfel> <53747FB8.2090706@thomasmore.be>
In-Reply-To: <53747FB8.2090706@thomasmore.be>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <33a1dbfc-bacb-4804-a83a-9915eca3183b@BY2FFO11FD032.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(199002)(189002)(164054003)(51704005)(377454003)(24454002)(479174003)(20776003)(81542001)(92726001)(76482001)(23756003)(77982001)(31966008)(86362001)(87936001)(70736001)(80022001)(79102001)(4396001)(71366001)(74502001)(65956001)(92566001)(65806001)(83506001)(83322001)(81342001)(64126003)(74662001)(50986999)(99396002)(83072002)(76176999)(77096999)(50466002)(74316001)(31696002)(47776003)(19580405001)(46102001)(85852003)(33646001)(54356999)(44976005)(65826006);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB015;H:xir-gw1;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0212BDE3BE
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 10:50 AM, Bart Tanghe wrote:
> On 05/15/2014 09:23 AM, Arnd Bergmann wrote:
>> On Wednesday 14 May 2014 13:26:13 Bart Tanghe wrote:
>>> @@ -0,0 +1,20 @@
>>> +Xilinx PWM controller
>>> +
>>> +Required properties:
>>> +- compatible: should be "xlnx,pwm-xlnx"
>>> +- add a clock source to the description
>>> +
>>> +Examples:
>>> +
>>> +               axi_timer_0: timer@42800000 {
>>> +                       clock-frequency = <100000000>;
>>> +                       clocks = <&clkc 15>;
>>> +                       compatible = "xlnx,xlnx-pwm";
>>> +                       reg = <0x42800000 0x10000>;
>>> +                       xlnx,count-width = <0x20>;
>>> +                       xlnx,gen0-assert = <0x1>;
>>> +                       xlnx,gen1-assert = <0x1>;
>>> +                       xlnx,one-timer-only = <0x0>;
>>> +                       xlnx,trig0-assert = <0x1>;
>>> +                       xlnx,trig1-assert = <0x1>;
>>> +               } ;
>>>
>>
>> It seems you are missing a mandatory "#pwm-cells" property.
>> How is anybody supposed to use this?
>>
>>     Arnd
>>
> 
> I've added some additional information in the documentation
> 
> 
> 
> Xilinx PWM controller
> 
> This driver works together with the Xilinx Axi timer hardware core.
> The core is available for the microblaze, powerpc and arm based Xilinx
> platforms.
> 
> The axi timer core is implemented in the pl (programmable logic) of the
> fpga. The amount is user defined. Each core has two timers and one pwm output.

For PWM you have to have 2 timers but core itself can be configured
to any configuration and I expect that any output has to be used.

Can you describe me your testing enviroment with zedboard?
Do you use any additional hw or are using just leds or any device
on zedboard?

Thanks,
Michal


