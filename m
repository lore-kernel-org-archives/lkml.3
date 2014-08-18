Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaHROhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:37:37 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:39503
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751860AbaHROhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:37:35 -0400
Message-ID: <53F21156.70400@opensource.altera.com>
Date: Mon, 18 Aug 2014 09:44:38 -0500
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <atull@altera.com>, <delicious.quinoa@gmail.com>,
        <dinguyen@altera.com>, <dougthompson@xmission.com>,
        <grant.likely@linaro.org>, <bp@alien8.de>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Subject: Re: [PATCHv9 3/3] arm: dts: Add Altera SDRAM controller bindings
References: <1406744573-609-1-git-send-email-tthayer@opensource.altera.com> <1406744573-609-4-git-send-email-tthayer@opensource.altera.com> <53F14DC2.70000@gmail.com>
In-Reply-To: <53F14DC2.70000@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR04CA045.namprd04.prod.outlook.com (10.141.154.163) To
 BL2PR03MB115.namprd03.prod.outlook.com (10.255.230.26)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03077579FF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009005)(6049001)(6009001)(164054003)(51704005)(24454002)(52604005)(199003)(189002)(479174003)(377454003)(77096002)(4396001)(65956001)(42186005)(81342001)(87976001)(23746002)(81542001)(102836001)(33656002)(66066001)(80022001)(92726001)(92566001)(83072002)(2201001)(85852003)(65806001)(83506001)(64706001)(47776003)(86362001)(107046002)(20776003)(64126003)(19580395003)(83322001)(54356999)(85306004)(31966008)(99396002)(50986999)(74662001)(76176999)(19580405001)(46102001)(65816999)(79102001)(105586002)(76482001)(101416001)(77982001)(50466002)(74502001)(106356001)(95666004)(21056001)(1121002)(921003)(2101003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB115;H:[137.57.160.203];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/17/2014 07:50 PM, Rob Herring wrote:
> On 07/30/2014 01:22 PM, tthayer@opensource.altera.com wrote:
>> From: Thor Thayer <tthayer@opensource.altera.com>
>>
>> Add the Altera SDRAM controller bindings and device tree changes to the Altera SoC project.
>>
>> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
>> ---
>> v2: Changes to SoC SDRAM EDAC code.
>>
>> v3: Implement code suggestions for SDRAM EDAC code.
>>
>> v4: Remove syscon from SDRAM controller bindings.
>>
>> v5: No Change, bump version for consistency.
>>
>> v6: Only map the ctrlcfg register as syscon.
>>
>> v7: No change. Bump for consistency.
>>
>> v8: No change. Bump for consistency.
>>
>> v9: Changes to support a MFD SDRAM controller with nested EDAC.
>> ---
>>   .../devicetree/bindings/arm/altera/socfpga-sdr.txt |   13 +++++++++++++
>>   arch/arm/boot/dts/socfpga.dtsi                     |   10 ++++++++++
>>   2 files changed, 23 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt
>> new file mode 100644
>> index 0000000..2bb1ddf
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdr.txt
>> @@ -0,0 +1,13 @@
>> +Altera SOCFPGA SDRAM Controller
>> +The SDRAM controller is implemented as a MFD so various drivers may
>> +nest under this main SDRAM controller binding.
>> +
>> +Required properties:
>> +- compatible : "altr,sdr";
>> +- reg : Should contain 1 register range(address and length)
>> +
>> +Example:
>> +	sdr@0xffc25000 {
>> +		compatible = "altr,sdr";
>> +		reg = <0xffc25000 0x1000>;
>> +	};
>> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
>> index 4676f25..ecb306d 100644
>> --- a/arch/arm/boot/dts/socfpga.dtsi
>> +++ b/arch/arm/boot/dts/socfpga.dtsi
>> @@ -603,6 +603,16 @@
>>   			};
>>   		};
>>   
>> +		sdr@0xffc25000 {
>> +			compatible = "altr,sdr";
>> +			reg = <0xffc25000 0x1000>;
>> +
>> +			sdramedac@0 {
>> +				compatible = "altr,sdram-edac";
>> +				interrupts = <0 39 4>;
>> +			};
> This doesn't match the documentation, but I don't think this is a move
> in the right direction anyway. Because Linux has/wants an MFD driver is
> not a reason to add a sub node. It is a single h/w block and DT should
> reflect that.
>
> Rob
Hi Rob,

Thanks for reviewing. After discussions with the community and 
internally, I reverted to using the syscon case in revision 10. I 
apologize for the confusion but the syscon method seems to be a cleaner 
solution. I submitted the sycon version on 8/11/14.

Thanks,

Thor

