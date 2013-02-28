Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3B1IyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:54:07 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16418 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3B1IyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:54:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 28 Feb 2013 00:53:12 -0800
Message-ID: <512F1ADF.90906@nvidia.com>
Date: Thu, 28 Feb 2013 14:22:47 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: J Keerthy <j-keerthy@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/4] documentation: add palmas dts definition
References: <1361164283-3133-1-git-send-email-j-keerthy@ti.com> <512E5144.9020105@wwwdotorg.org>
In-Reply-To: <512E5144.9020105@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 February 2013 12:02 AM, Stephen Warren wrote:
> On 02/17/2013 10:11 PM, J Keerthy wrote:
> +- interrupt-parent : The parent interrupt controller.
> +
> +Optional node:
> +- Child nodes contain in the palmas. The palmas family is made of several
> +  variants that support a different number of features.
> +  The child nodes will thus depend of the capability of the variant.
> Are there DT bindings for those child nodes anywhere?
>
> Representing each internal component as a separate DT node feels a
> little like designing the DT bindings to model the Linux-internal MFD
> structure. DT bindings should be driven by the HW design and OS-agnostic.
>
>  From a DT perspective, is there any need at all to create a separate DT
> node for each component? This would only be needed or useful if the
> child IP blocks (and hence DT bindings for those blocks) could be
> re-used in other top-level devices that aren't represented by this
> top-level ti,palmas DT binding. Are the HW IP blocks here re-used
> anywhere, or will they be?


I dont think that child IP block can be used outside of the palma 
although other mfd device may have same IP.

The child driver very much used the palma's API for register access and 
they can not be separated untill driver is write completely independent 
of palmas API. Currently, child driver include the palma header, uses 
palma mfd stcruture and plama's api for accessing registers.

>> +    interrupt-controller;
>> +    #interrupt-cells = <1>;
>> +    interrupt-parent = <&gic>;
>> +    #address-cells = <1>;
>> +    #size-cells = <0>;
>> +
>> +	ti,mux-pad1 = <0x00>;
>> +	ti,mux-pad2 = <0x00>;
>> +	ti,power-ctrl = <0x03>;
>> +
>> +	palmas_pmic {
> Just "pmic" seems simpler, although I dare say the node name isn't
> really used for anything.

Stephen,
Just curios, why do we require the palma_pmic node at all, We can start 
with regulator node directly. Is it not too much nested here?



>
> +
> +    palmas_rtc {
> +        compatible = "ti,palmas_rtc";
> +        interrupts = <8 9>;
> Are the interrupt outputs of the RTC fed directly to the GIC interrupt
> mentioned in the top-level Palmas node, or do these interrupts feed into
> a top-level IRQ controller in the Palmas device, which then feeds into
> the external IRQ controller?

The interrupt goes to the chip-internal irq, not to external of chip.  
We have only one int line from chip which can be connected to processor/GIC.
yes, interrupt parent need to be define here to get the proper interrupt 
number.
