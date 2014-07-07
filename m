Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaGGIef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:34:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58557 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaGGIec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:34:32 -0400
Message-ID: <53BA5B8A.5010805@ti.com>
Date: Mon, 7 Jul 2014 11:34:18 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <kishon@ti.com>, <balbi@ti.com>, <nsekhar@ti.com>, <nm@ti.com>,
        <george.cherian@ti.com>, <sergei.shtylyov@cogentembedded.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH v2 1/6] ARM: dts: dra7-evm: Make VDDA_1V8_PHY supply always
 on
References: <1404467748-12154-1-git-send-email-rogerq@ti.com> <1404467748-12154-2-git-send-email-rogerq@ti.com> <20140707082922.GI28884@atomide.com>
In-Reply-To: <20140707082922.GI28884@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 07/07/2014 11:29 AM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [140704 02:57]:
>> After clarification from the hardware team it was found that
>> this 1.8V PHY supply can't be switched OFF when SoC is Active.
>>
>> Since the PHY IPs don't contain isolation logic built in the design to
>> allow the power rail to be switched off, there is a very high risk
>> of IP reliability and additional leakage paths which can result in
>> additional power consumption.
>>
>> The only scenario where this rail can be switched off is part of Power on
>> reset sequencing, but it needs to be kept always-on during operation.
>>
>> This patch is required for proper functionality of USB, SATA
>> and PCIe on DRA7-evm.
>>
>> CC: Rajendra Nayak <rnayak@ti.com>
>> CC: Tero Kristo <t-kristo@ti.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Best that you queue this with the series:

This patch doesn't have any dependency with the others and we're not even sure if
this series will hit 3.16.

But this 1V8 regulator _is_ required for normal operation of the SoC, whether the
PHYs are in use or not.

Can you please queue just this patch for SoC fixes for 3.16? Thanks.

cheers,
-roger

> 
> Acked-by: Tony Lindgren <tony@atomide.com>
> 
>> ---
>>  arch/arm/boot/dts/dra7-evm.dts | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
>> index 4adc280..8308954 100644
>> --- a/arch/arm/boot/dts/dra7-evm.dts
>> +++ b/arch/arm/boot/dts/dra7-evm.dts
>> @@ -240,6 +240,7 @@
>>  					regulator-name = "ldo3";
>>  					regulator-min-microvolt = <1800000>;
>>  					regulator-max-microvolt = <1800000>;
>> +					regulator-always-on;
>>  					regulator-boot-on;
>>  				};
>>  
>> -- 
>> 1.8.3.2
>>

