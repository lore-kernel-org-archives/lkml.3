Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966037AbaFRJuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:50:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39081 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964840AbaFRJut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:50:49 -0400
Message-ID: <53A160D1.8000908@ti.com>
Date: Wed, 18 Jun 2014 15:20:09 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        devicetree <devicetree@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the
 MiPHY365x
References: <1400766819-22286-1-git-send-email-lee.jones@linaro.org> <1400766819-22286-2-git-send-email-lee.jones@linaro.org> <5396E561.4020805@ti.com> <20140617112353.GB4139@lee--X1>
In-Reply-To: <20140617112353.GB4139@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 17 June 2014 04:53 PM, Lee Jones wrote:
>>> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
>>> devices. It has 2 ports which it can use for either; both SATA, both
>>> PCIe or one of each in any configuration.
>>
>> I've asked others who wrote multi-phy PHY providers to model each individual
>> PHY as sub-node of the PHY provider. So It's only fair I ask you the same to
>> do. So in this case the dt node should look something like:
>>
>> 	miphy365x_phy: miphy365x@fe382000 {
>> 		compatible = "st,miphy365x-phy";
>> 		#phy-cells = <2>;
>> 		st,syscfg = <&syscfg_rear>;
>> 		channel@0 {
>> 			reg =	<0xfe382000 0x100>, <0xfe394000 0x100>;
>> 			reg-names = "sata", "pcie";
>> 		}
>>
>> 		channel@1{
>> 			reg =	<0xfe38a000 0x100>, <0xfe804000 0x100>;
>> 			reg-names = "sata", "pcie";
>> 		}
>>
>> 	};
> 
> I'm interested to know why you've taken this approach, as it makes the
> code much more complex.  The DT framework goes to the trouble of

It looks to be much closer representation of the hardware in dt. It also
enables to have more control of each individual PHYs. For example, we can have
something like status="disabled" for channels which is disabled.

> converting all addresses to to resources so drivers can easily pull
> them out using platform_get_resource() and friends.  Pushing the reg

right. Can't we use of_address_to_resource here?
> properties down into a child node means that we have to now iterate
> over the sub-nodes and pull them out manually.  This will lead to a

You anyway iterate while creating PHYs based on some constant. Now you have to
iterate over the sub-nodes.
> pretty messy implementation IMHO.


> 
> Can you point me in the direction of previous implementations where you
> have stipulated the same set of constraints please?

ah.. there isn't any. The author of the other multi-phy driver [1] also feels
this will just add to the complexity of the driver.

Maybe we should ask the opinion of others?

[1] -> http://www.spinics.net/lists/linux-sh/msg32087.html
> 
