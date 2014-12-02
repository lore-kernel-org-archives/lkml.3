Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbaLBR4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:56:42 -0500
Received: from mail-bl2on0097.outbound.protection.outlook.com ([65.55.169.97]:29760
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754330AbaLBR4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:56:39 -0500
Message-ID: <547DFD0F.7000004@opensource.altera.com>
Date: Tue, 2 Dec 2014 11:55:27 -0600
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "bp@alien8.de" <bp@alien8.de>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tthayer.linux@gmail.com" <tthayer.linux@gmail.com>
Subject: Re: [PATCHv5 5/5] arm: dts: Add Altera L2 Cache and OCRAM EDAC
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com> <1415751263-1830-6-git-send-email-tthayer@opensource.altera.com> <20141202145735.GL23671@leverpostej>
In-Reply-To: <20141202145735.GL23671@leverpostej>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0031.namprd08.prod.outlook.com (10.141.200.11) To
 BY2PR03MB128.namprd03.prod.outlook.com (10.242.36.28)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB128;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB128;
X-Forefront-PRVS: 0413C9F1ED
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(51704005)(24454002)(199003)(189002)(164054003)(479174003)(377454003)(42186005)(106356001)(40100003)(105586002)(87976001)(122386002)(15975445006)(120916001)(99396003)(107046002)(62966003)(77156002)(64126003)(50466002)(68736005)(23746002)(77096005)(31966008)(95666004)(46102003)(102836001)(66066001)(4396001)(33656002)(65956001)(92566001)(92726001)(15202345003)(59896002)(86362001)(21056001)(76176999)(97736003)(87266999)(65816999)(54356999)(19580395003)(83506001)(101416001)(80316001)(20776003)(47776003)(19300405004)(64706001)(19580405001)(50986999)(110136001)(562404015);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB128;H:[137.57.160.203];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB128;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/02/2014 08:57 AM, Mark Rutland wrote:
> On Wed, Nov 12, 2014 at 12:14:23AM +0000, tthayer@opensource.altera.com wrote:
>> From: Thor Thayer <tthayer@opensource.altera.com>
>>
>> Adding the device tree entries and bindings needed to support
>> the Altera L2 cache and On-Chip RAM EDAC. This patch relies upon
>> an earlier patch to declare and setup On-chip RAM properly.
>> http://www.spinics.net/lists/devicetree/msg51117.html
>>
>> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>

<snip>

>> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
>> @@ -0,0 +1,15 @@
>> +Altera SoCFPGA L2 cache Error Detection and Correction [EDAC]
>> +
>> +Required Properties:
>> +- compatible : Should be "altr,l2-edac"
>> +- reg : Address and size for ECC error interrupt clear registers.
>> +- interrupts : Should be single bit error interrupt, then double bit error
>> +	interrupt. Note the rising edge type.
>> +
>> +Example:
>> +
>> +	l2edac@ffd08140 {
>> +		compatible = "altr,l2-edac";
>> +		reg = <0xffd08140 0x4>;
>> +		interrupts = <0 36 1>, <0 37 1>;
>> +	};
>
> Judging by the size of the reg entry, this is part of a larger block
> (the same one the OCRAM EDAC lives in). Why isn't that larger block
> described?
>
> EDAC is a Linux subsystem name, but typically not the HW block name.
> What HW block does this live in?
>

Yes, this register is part of the ECC block of registers. In order to 
get each probe function to run, the L2 EDAC and OCRAM EDAC had to be at 
the top level of the device tree. If they are children of a parent node, 
the probe functions aren't executed.
Is there a better way or example I should follow?

>> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
>> new file mode 100644
>> index 0000000..31ab205
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt

<snip>

>> +
>>   		L2: l2-cache@fffef000 {
>> -			compatible = "arm,pl310-cache";
>> +			compatible = "arm,pl310-cache", "syscon";
>
> NAK.
>
> Why are you marking the PL310 as a syscon device? It is most definitely
> _NOT_ a shared set of registers lumped together.
>

Unfortunately, the register is locked for exclusive access by the L2 
cache driver. I read your comment on patch 4 and will find a better way.

> Thanks,
> Mark.
>
