Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaHAFKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:10:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47350 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbaHAFKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:10:12 -0400
Message-ID: <53DB210B.5010204@ti.com>
Date: Fri, 1 Aug 2014 08:09:31 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, <nsekhar@ti.com>,
        <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, <pawel.moll@arm.com>,
        <khilman@deeprootsystems.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/6] ARM: DTS: da850: Add node for edma0
References: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com> <1406801934-23334-3-git-send-email-peter.ujfalusi@ti.com> <53DA5230.1050200@cogentembedded.com>
In-Reply-To: <53DA5230.1050200@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 05:26 PM, Sergei Shtylyov wrote:
> On 07/31/2014 02:18 PM, Peter Ujfalusi wrote:
> 
>> Add DT node for edma0.
> 
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>   arch/arm/boot/dts/da850.dtsi | 6 ++++++
>>   1 file changed, 6 insertions(+)
> 
>> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
>> index b695548dbb4e..41ce4e8bf227 100644
>> --- a/arch/arm/boot/dts/da850.dtsi
>> +++ b/arch/arm/boot/dts/da850.dtsi
>> @@ -150,6 +150,12 @@
>>               };
>>
>>           };
>> +        edma0: edma@01c00000 {
>> +            compatible = "ti,edma3";
>> +            reg =    <0x0 0x10000>;
> 
>    Why the mismatch between the unit-address part of the node name and the
> "reg" property?

For some reason the whole da850 uses offset from 0x01c00000 for the SoC IPs.
The nodes are under 'soc' and that has the ranges attribute.
I do not really like this either.

> 
>> +            interrupts = <11 13 12>;
>> +            #dma-cells = <1>;
>> +        };
> 
> WBR, Sergei
> 

-- 
Péter
