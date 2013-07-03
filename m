Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3GCINv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:13:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60491 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab3GCINr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:13:47 -0400
Message-ID: <51D3DCD7.2010209@ti.com>
Date: Wed, 3 Jul 2013 13:42:07 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Hebbar Gururaja <gururaja.hebbar@ti.com>,
        <davinci-linux-open-source@linux.davincidsp.com>, <tony@atomide.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <benoit.cousson@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] ARM: dts: AM33XX: update rtc node compatibility
References: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com> <1372412109-986-5-git-send-email-gururaja.hebbar@ti.com> <51D26F61.7080308@ti.com>
In-Reply-To: <51D26F61.7080308@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gururaja,

On 7/2/2013 11:42 AM, Sekhar Nori wrote:
> Changing to Benoit's gmail id since he apparently wont access TI mail
> anymore.
> 
> On 6/28/2013 3:05 PM, Hebbar Gururaja wrote:
>> Since AM33xx  RTC IP has RTC_IRQWAKEEN to support Alarm Wake-up.
>>
>> Update the rtc compatible property to "ti,am3352-rtc" to enable handling
>> of this feature inside rtc-omap driver.
>>
>> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> Cc: Kevin Hilman <khilman@linaro.org>
>> Cc: b-cousson@ti.com
>> ---
>> :100644 100644 77aa1b0... dde180a... M	arch/arm/boot/dts/am33xx.dtsi
>>  arch/arm/boot/dts/am33xx.dtsi |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
>> index 77aa1b0..dde180a 100644
>> --- a/arch/arm/boot/dts/am33xx.dtsi
>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>> @@ -297,7 +297,7 @@
>>  		};
>>  
>>  		rtc@44e3e000 {
>> -			compatible = "ti,da830-rtc";
>> +			compatible = "ti,am3352-rtc";
> 
> compatible is a list so you can instead do:
> 	
> 	compatible = "ti,am3352-rtc", "ti,da830-rtc";
> 
> That way the dts works irrespective of driver updates. When driver
> supports enhanced features of hardware, they are available to the user
> else the basic functionality still works.

On doing some experiments myself, the of_device_id which gets selected
during probe depends on the order in which its entry appears in the
match table inside the driver rather than how the compatible string is
written. I think this puts undue dependency on how the driver is
written, so I am okay with providing a single compatible value like the
way you have done ATM.

I do think the string appearing first in the compatible list is what
should be selected if a match is available but I am not sure if there
are other considerations due to which of_match_device() is written the
way it is written.

Thanks,
Sekhar
