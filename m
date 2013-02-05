Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab3BEJGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:06:31 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49780 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3BEJGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:06:14 -0500
Message-ID: <5110CBB9.5080307@ti.com>
Date: Tue, 5 Feb 2013 14:37:05 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: kishon <kishon@ti.com>
CC: <balbi@ti.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <gg@slimlogic.co.uk>, <s-guiriec@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 4/6] ARM: dts: omap5: add dwc3 omap dt data
References: <1359112312-6918-1-git-send-email-kishon@ti.com> <1359112312-6918-5-git-send-email-kishon@ti.com> <510432BF.80808@mvista.com> <5110C2E6.30504@ti.com> <20130205083828.GE32118@arwen.pp.htv.fi> <5110C6EC.6050606@ti.com>
In-Reply-To: <5110C6EC.6050606@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2013 02:16 PM, kishon wrote:
> Hi,
>
> On Tuesday 05 February 2013 02:08 PM, Felipe Balbi wrote:
>> On Tue, Feb 05, 2013 at 01:59:26PM +0530, kishon wrote:
>>> On Sunday 27 January 2013 01:17 AM, Sergei Shtylyov wrote:
>>>> Hello.
>>>>
>>>> On 25-01-2013 15:11, Kishon Vijay Abraham I wrote:
>>>>
>>>>> Add dwc3 omap glue data to the omap5 dt data file. The information
>>>>> about
>>>>> the dt node added here is available @
>>>>> Documentation/devicetree/bindings/usb/omap-usb.txt
>>>>
>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>>> ---
>>>>>   arch/arm/boot/dts/omap5.dtsi |   11 +++++++++++
>>>>>   1 file changed, 11 insertions(+)
>>>>
>>>>> diff --git a/arch/arm/boot/dts/omap5.dtsi
>>>>> b/arch/arm/boot/dts/omap5.dtsi
>>>>> index 5f59bf2..1703a72 100644
>>>>> --- a/arch/arm/boot/dts/omap5.dtsi
>>>>> +++ b/arch/arm/boot/dts/omap5.dtsi
>>>>> @@ -513,6 +513,17 @@
>>>>>               ti,type = <2>;
>>>>>           };
>>>>>
>>>>> +        omap_dwc3@4a020000 {
>>>>> +            compatible = "ti,dwc3";
>>>>> +            ti,hwmods = "usb_otg_ss";
>>>>> +            reg = <0x4a020000 0x1ff>;
>>>>
>>>>     Shoudn't the "reg" length be 0x200 here? It's length, not limit.
>>>
>>> I think 0x1ff is correct. I got the data from hwmod data.
>>
>> hwmod is utterly wrong. Looking at TRM, it says the size here is 64KiB
>> (0x10000), so is the size for dwc3 itself. Please don't blindly trust
>> hwmod, make sure you read data from TRM ;-)
>
> hmm..ok. But it has only 17 registers :-D
>
As Felipe said, it should be 0x200. And if you are
interested in lesser space, there is no need to map entire 64 KB
address space if it isn't being used.

Regards,
Santosh

