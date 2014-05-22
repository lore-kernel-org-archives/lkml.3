Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaEVNwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:52:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37402 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbaEVNv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:51:58 -0400
Message-ID: <537E00DD.4060702@ti.com>
Date: Thu, 22 May 2014 16:51:25 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <santosh.shilimkar@ti.com>
CC: <devicetree@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <m-karicheri2@ti.com>, <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch] ARM: dts: keystone: add pll controller syscon entry
References: <1400681875-24432-1-git-send-email-ivan.khoronzhuk@ti.com> <537CEE13.5040908@cogentembedded.com> <537CEEFA.8080805@cogentembedded.com>
In-Reply-To: <537CEEFA.8080805@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/21/2014 09:22 PM, Sergei Shtylyov wrote:
> On 05/21/2014 10:18 PM, Sergei Shtylyov wrote:
>
>>> The pll controller register set includes sets of registers with
>>> different purposes, so it's logically to add syscon entry to be able
>>> to access them from appropriate places.
>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>> ---
>
>>> Based on linux-next/master
>
>>>   arch/arm/boot/dts/keystone.dtsi | 5 +++++
>>>   1 file changed, 5 insertions(+)
>>
>>> diff --git a/arch/arm/boot/dts/keystone.dtsi 
>>> b/arch/arm/boot/dts/keystone.dtsi
>>> index d9f99e7..5e67c5b 100644
>>> --- a/arch/arm/boot/dts/keystone.dtsi
>>> +++ b/arch/arm/boot/dts/keystone.dtsi
>>> @@ -66,6 +66,11 @@
>>>           ranges = <0x0 0x0 0x0 0xc0000000>;
>>>           dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;
>>>
>>> +        pllctrl: pll_controller {
>
>>    I think it's better to follow the pattern established by 
>> "reset-controller"
>> and use hyphen ISO dash in the node name. This is also a common 
>> practice to
>
>    Oops, hyphen and dash are basically the same thing; I meant 
> s/dash/underscore/.

You meant s/underscore/dash.
I'll replace.
FYI: the change is included in new series [Patch v5 0/7] Introduce 
keystone reset driver

And this patch is squashed in:
[Patch v5 6/7] ARM: dts: keystone: update reset node to work with reset 
driver

Thanks.

>
>> use hyphens in the device trees overall.
>
>>> +            compatible = "ti,keystone-pllctrl", "syscon";
>>> +            reg = <0x2310000 0x200>;
>>> +        };
>>> +
>>>           rstctrl: reset-controller {
>>>               compatible = "ti,keystone-reset";
>>>               reg = <0x023100e8 4>;    /* pll reset control reg */
>>>
>
> WBR, Sergei
>

-- 
Regards,
Ivan Khoronzhuk

