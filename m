Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122Ab3DCFdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:33:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47940 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762071Ab3DCFdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:33:39 -0400
Message-ID: <515BBEF7.2030404@ti.com>
Date: Wed, 3 Apr 2013 11:02:39 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <mchehab@redhat.com>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <grant.likely@secretlab.ca>, <linux@arm.linux.org.uk>,
        <javier@dowhile0.org>, <cesarb@cesarb.net>, <arnd@arndb.de>,
        <eballetbo@gmail.com>, <devicetree-discuss@lists.ozlabs.org>,
        <rob.herring@calxeda.com>, <swarren@nvidia.com>,
        <sylvester.nawrocki@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <b-cousson@ti.com>,
        <gregkh@linuxfoundation.org>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <santosh.shilimkar@ti.com>, <rob@landley.net>,
        <akpm@linux-foundation.org>, <davem@davemloft.net>
Subject: Re: [PATCH v4 1/6] drivers: phy: add generic PHY framework
References: <1364449408-9510-1-git-send-email-kishon@ti.com> <1364449408-9510-2-git-send-email-kishon@ti.com> <5154658A.3080209@wwwdotorg.org> <515A98B3.7090405@ti.com> <515AFC06.8000502@wwwdotorg.org>
In-Reply-To: <515AFC06.8000502@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 April 2013 09:10 PM, Stephen Warren wrote:
> On 04/02/2013 02:37 AM, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Thursday 28 March 2013 09:15 PM, Stephen Warren wrote:
>>> On 03/27/2013 11:43 PM, Kishon Vijay Abraham I wrote:
>>>> The PHY framework provides a set of APIs for the PHY drivers to
>>>> create/destroy a PHY and APIs for the PHY users to obtain a reference
>>>> to the
>>>
>>>> diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt
>
>>>> +PHY subsystem refer Documentation/phy.txt
>>>> +
>>>> +PHY device node
>>>> +===============
>>>> +
>>>> +Optional Properties:
>>>> +#phy-cells:    Number of cells in a PHY specifier;  The meaning of all those
>>>> +        cells is defined by the binding for the phy node. However
>>>> +        in-order to return the correct PHY, the PHY susbsystem
>>>> +        requires the first cell always refers to the port.
>>>
>>> Why impose that restriction? Other DT bindings do not.
>>>
>>> This is typically implemented by having each provider driver implement a
>>> .of_xlate() operation, which parses all of the specifier cells, and
>>> returns the ID of the object it represents. This allows bindings to use
>>> whatever arbitrary representation they want.
>>
>> Do you mean something like this
>>
>> struct phy *of_phy_get(struct device *dev, int index)
>> {
>>      struct phy *phy = NULL;
>>      struct phy_bind *phy_map = NULL;
>>      struct of_phandle_args args;
>>      struct device_node *node;
>>
>>      if (!dev->of_node) {
>>          dev_dbg(dev, "device does not have a device node entry\n");
>>          return ERR_PTR(-EINVAL);
>>      }
>>
>>      ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-cells",
>>          index, &args);
>>      if (ret) {
>>          dev_dbg(dev, "failed to get phy in %s node\n",
>>              dev->of_node->full_name);
>>          return ERR_PTR(-ENODEV);
>>      }
>
> Looks good.
>
>> //Here we have to get a reference to the phy in order to call of_xlate
>> which seems a little hacky to me. I'm not sure how else can we call the
>> provider driver :-(
>>      phy = of_phy_lookup(dev, node);
>>      if (IS_ERR(phy) || !try_module_get(phy->ops->owner)) {
>>          phy = ERR_PTR(-EPROBE_DEFER);
>>          goto err0;
>>      }
>
> I think the concept of a "PHY provider" and a "PHY instance" are different.
>
> of_xlate should be called on a "PHY provider", and return a "PHY
> instance". Hence, above you want to only look up a "PHY provider", so
> there's no hackiness involved.

Cool. That makes it a lot clearer.

Thanks
Kishon
