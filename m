Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaHOQkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:40:35 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:14250
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751182AbaHOQkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:40:33 -0400
Message-ID: <53EE398D.3060509@opensource.altera.com>
Date: Fri, 15 Aug 2014 11:47:09 -0500
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: atull <atull@opensource.altera.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Subject: Re: [PATCHv10 2/2] arm: dts: Add Altera SDRAM EDAC bindings & devicetree
 entries.
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com> <1407770293-27190-3-git-send-email-tthayer@opensource.altera.com> <73vbputf04.fsf@dude.hi.pengutronix.de> <alpine.DEB.2.02.1408151035110.21645@atx-linux-37>
In-Reply-To: <alpine.DEB.2.02.1408151035110.21645@atx-linux-37>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR08CA0038.namprd08.prod.outlook.com (10.242.217.166) To
 BY2PR03MB126.namprd03.prod.outlook.com (10.242.36.21)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0304E36CA3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009004)(6009001)(6049001)(189002)(51704005)(52604005)(51914003)(51444003)(479174003)(199003)(377454003)(24454002)(92566001)(99396002)(33656002)(31966008)(65816999)(64706001)(64126003)(15202345003)(50986999)(50466002)(21056001)(86362001)(85852003)(92726001)(83072002)(575784001)(101416001)(76176999)(46102001)(80316001)(102836001)(54356999)(83322001)(95666004)(107046002)(76482001)(47776003)(20776003)(105586002)(15975445006)(79102001)(83506001)(87976001)(66066001)(65806001)(59896001)(77982001)(65956001)(80022001)(74662001)(42186005)(4396001)(74502001)(81342001)(81542001)(93886004)(19580405001)(87266999)(106356001)(19580395003)(85306004)(77096002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB126;H:[137.57.160.203];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/15/2014 11:07 AM, atull wrote:
> On Fri, 15 Aug 2014, Steffen Trumtrar wrote:
>
>> Hi!
> Hello
>
> Thanks for the feedback...
>
>> tthayer@opensource.altera.com writes:
>>
>>> From: Thor Thayer <tthayer@opensource.altera.com>
>>>
>>> Add the Altera SDRAM EDAC bindings and device tree changes to the Altera SoC project.
>>>
>>> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
>>> ---
>>> v2: Changes to SoC SDRAM EDAC code.
>>>
>>> v3: Implement code suggestions for SDRAM EDAC code.
>>>
>>> v4: Remove syscon from SDRAM controller bindings.
>>>
>>> v5: No Change, bump version for consistency.
>>>
>>> v6: Only map the ctrlcfg register as syscon.
>>>
>>> v7: No change. Bump for consistency.
>>>
>>> v8: No change. Bump for consistency.
>>>
>>> v9: Changes to support a MFD SDRAM controller with nested EDAC.
>>>
>>> v10: Revert to using syscon based on feedback.
>>> ---
>>>   .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +++++++++++++++
>>>   arch/arm/boot/dts/socfpga.dtsi                     |   11 +++++++++++
>>>   2 files changed, 26 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
>>> new file mode 100644
>>> index 0000000..d0ce01d
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
>>> @@ -0,0 +1,15 @@
>>> +Altera SOCFPGA SDRAM Error Detection & Correction [EDAC]
>>> +The EDAC accesses a range of registers in the SDRAM controller.
>>> +
>>> +Required properties:
>>> +- compatible : should contain "altr,sdram-edac";
>>> +- altr,sdr-syscon : phandle of the sdr module
>>> +- interrupts : Should contain the SDRAM ECC IRQ in the
>>> +	appropriate format for the IRQ controller.
>>> +
>>> +Example:
>>> +	sdramedac {
>>> +		compatible = "altr,sdram-edac";
>>> +		altr,sdr-syscon = <&sdr>;
>>> +		interrupts = <0 39 4>;
>>> +	};
>>> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
>>> index 4676f25..45b361e 100644
>>> --- a/arch/arm/boot/dts/socfpga.dtsi
>>> +++ b/arch/arm/boot/dts/socfpga.dtsi
>>> @@ -603,6 +603,17 @@
>>>   			};
>>>   		};
>>>   
>>> +		sdr: sdr@ffc25000 {
>>> +			compatible = "syscon";
>>> +			reg = <0xffc25000 0x1000>;
>>> +		};
>>> +
>>> +		sdramedac {
>>> +			compatible = "altr,sdram-edac";
>>> +			altr,sdr-syscon = <&sdr>;
>>> +			interrupts = <0 39 4>;
>>> +		};
>>> +
>>>   		L2: l2-cache@fffef000 {
>>>   			compatible = "arm,pl310-cache";
>>>   			reg = <0xfffef000 0x1000>;
>> Sorry, but I personally still don't like this approach.
> This is a normal use of syscon.  Syscon is great for this case
> where multiple drivers need access to an ip block's register
> range but there is otherwise no need to write a MFD from scratch
> to allow that.  I think that's the purpose of syscon in the first
> place.
>
>> If we do it like this however, shouldn't the different regions of the
>> SDR (EDAC, FPGAPORTRST, ...) at least be child nodes of the syscon?
>> That seems to match the syscon binding and describes the actual hardware
>> better IMHO.
> I like that; it would be clean and clear, but I don't think syscon is
> written such that that would actually work.  I haven't seen anybody else
> do it that way.
Hi Steffen!

Building on Alan's points, I don't see the reference to the child nodes 
in the syscon.txt binding documentation - can you point out what I'm 
missing?

I based this patch on other examples of syscon, and there aren't child 
nodes (exynos5250.dtsi, omap3.dtsi, etc). According to my understanding 
of the device tree parsing, the parent needs to register child nodes. 
Since syscon is the parent and doesn't register the child nodes, they 
won't be automatically probed. The other syscon implementations are at 
the same level as the syscon and use a phandle to the syscon (for 
instance the omap3.dtsi).

Thanks for reviewing!

Thor
>> Oh, and "reg = <...>" for the sdram-edac, maybe ?
> How would that work?  Syscon is already mapping the whole register range
> for the sdr block.  Are you proposing a device tree binding that this
> Linux driver would ignore, but some other driver in some other OS might
> find useful in the future?  I'd rather not put duplicate information
> in two places, too easy for it to get out of sync.
>
>> How would I know where the start address of the EDAC is, if I would use
>> this DT on another OS where I don't have the same driver?
> The start address of the EDAC is an offset into the range mapped by
> syscon here.  The driver knows what the register offsets are.
>
> If we are talking about this device tree being used by some other OS
> that is not aware of syscon, then that OS won't know what's going on and
> some modification of the DT will be needed.  I have been advised that
> u-boot will need a significantly different DT, though I don't know
> what the issues are there.
>
>> Regards,
>> Steffen
>>
>> -- 
>> Pengutronix e.K.                           | Steffen Trumtrar            |
>> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
>> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>

