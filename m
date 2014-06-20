Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaFTTDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:03:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40337 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaFTTDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:03:31 -0400
Message-ID: <53A48553.2080504@ti.com>
Date: Fri, 20 Jun 2014 15:02:43 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robherring2@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] dt/documentation: add specification of dma bus information
References: <1401981720-6946-1-git-send-email-santosh.shilimkar@ti.com> <CAL_JsqJAtWnHKPVpDsdOOzT_X=npc3hroLNTGqULM2SJr=1OEg@mail.gmail.com> <53A46CB7.1030109@ti.com> <4193075.zZSpRTFEYz@wuerfel>
In-Reply-To: <4193075.zZSpRTFEYz@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 June 2014 02:56 PM, Arnd Bergmann wrote:
> On Friday 20 June 2014 13:17:43 Santosh Shilimkar wrote:
>>>> +                       dma-coherent;
>>>> +                       dma-ranges;
>>>> +
>>>> +                       dwc3@2690000 {
>>>> +                               compatible = "synopsys,dwc3";
>>>> +                               [...]
>>>> +                       };
>>>
>>> This example is a bit strange. I don't understand the relationship
>>> between keystone-dwc3 and synopsys,dwc3, nor do I want to. I'd prefer
>>> to see a simple example here.
> 
> 
>>> dma-ranges is a property of the parent which you show, but
>>> dma-coherent originally was a property of the bus master itself. While
>>> we need to support that, are we changing that? We need to be clear on
>>> where the property belongs even if the kernel is more lax.
>>>
>> I don't think we are changing it fundamentally but may be I missing
>> your point. The dma-coherent as is now a per-device property.
>> USB is one of the bus master supports coherency and hence showed
>> up in above example.
> 
> I think it's enough if you just drop the "synopsys,dwc3" node and the
> intermediate dma-ranges property from the example, leaving the
> dma-coherent property in the "ti,keystone-dwc3" node.
> 
Thanks Arnd. That should avoid the confusion. Just to see if Rob is
fine by it, the example will look like below.

Example:
soc {
		compatible = "ti,keystone","simple-bus";
		ranges = <0x0 0x0 0x0 0xc0000000>;
		dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;

		[...]

		usb: usb@2680000 {
			compatible = "ti,keystone-dwc3";

			[...]
			dma-coherent;
		};
};

Regards,
Santosh
