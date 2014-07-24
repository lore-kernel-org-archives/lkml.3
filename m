Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbaGXP6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:58:14 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:54956 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759390AbaGXP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:58:12 -0400
Message-ID: <53D12CF6.6070502@atmel.com>
Date: Thu, 24 Jul 2014 17:57:42 +0200
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] ARM: at91: change compatibility string for sama5d3x
 gem
References: <cover.1406192657.git.cyrille.pitchen@atmel.com> <b8cbfb4e8d5d156d477634164c21cfa6f509c4ea.1406192657.git.cyrille.pitchen@atmel.com> <20140724151529.GA26190@leverpostej>
In-Reply-To: <20140724151529.GA26190@leverpostej>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/07/2014 17:15, Mark Rutland a écrit :
> On Thu, Jul 24, 2014 at 12:51:02PM +0100, Cyrille Pitchen wrote:
>> this new compatibility string prevents macb/gem driver from using the
>> scatter-gather and gso features on sama5d3x boards.
> 
> What will happen were the driver to attempt to use the features on this
> board?
> 
> How will this affect existing DTBs?
> 
> Thanks,
> Mark.
>
Hi Mark,

patch 2 for then scatter-gather feature introducted a new compatible string
"atmel,sama5d3-gem". Its associated config has the MACB_CAPS_SG_DISABLED flag
so the feature is not available indeed.

patch 2 also set the very same flag for the config associated to the already 
existing strings "cdns,pc302-gem" and "cdns,gem". Then if you don't update 
your device tree, the scatter-gather feature won't be enabled for gem anyway. 
However SG feature will be enabled for the old macb.

The main idea is to do the change in two steps to avoid indroducing bugs. This
series of patches is the first step. Later an additionnal patch may be 
introduced to enable SG feature for gem on all platforms but sama5d3x. This 
should be done by removing the MACB_CAPS_SG_DISABLED flag from pc302gem_config.
Till then you don't need to update your device tree.

For now, the SG feature is known to be broken on sama5d3x and there is work in 
progress with Cadence support to fix this issue. It seems to be specific to 
sama5d3x gem. SG feature was successfully tested on sama5d3x macb and also on 
sama5d4 gem.

Regards,

Cyrille

>>
>> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
>> ---
>>  arch/arm/boot/dts/sama5d3_gmac.dtsi | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/sama5d3_gmac.dtsi b/arch/arm/boot/dts/sama5d3_gmac.dtsi
>> index a6cb050..de5ed59 100644
>> --- a/arch/arm/boot/dts/sama5d3_gmac.dtsi
>> +++ b/arch/arm/boot/dts/sama5d3_gmac.dtsi
>> @@ -74,7 +74,7 @@
>>  			};
>>  
>>  			macb0: ethernet@f0028000 {
>> -				compatible = "cdns,pc302-gem", "cdns,gem";
>> +				compatible = "atmel,sama5d3-gem";
>>  				reg = <0xf0028000 0x100>;
>>  				interrupts = <34 IRQ_TYPE_LEVEL_HIGH 3>;
>>  				pinctrl-names = "default";
>> -- 
>> 1.8.2.2
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>

