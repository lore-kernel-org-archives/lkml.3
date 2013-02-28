Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3B1LVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:21:39 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:42173 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab3B1LVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:21:38 -0500
Message-ID: <512F3DC0.8020302@slimlogic.co.uk>
Date: Thu, 28 Feb 2013 11:21:36 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, J Keerthy <j-keerthy@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b-cousson@ti.com" <b-cousson@ti.com>
Subject: Re: [PATCH 1/4] documentation: add palmas dts definition
References: <1361164283-3133-1-git-send-email-j-keerthy@ti.com> <512E5144.9020105@wwwdotorg.org> <512F1ADF.90906@nvidia.com> <512F2A29.8080708@slimlogic.co.uk> <512F3118.6030806@nvidia.com> <512F3810.30109@slimlogic.co.uk>
In-Reply-To: <512F3810.30109@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/13 10:57, Graeme Gregory wrote:
> On 28/02/13 10:27, Laxman Dewangan wrote:
>> On Thursday 28 February 2013 03:28 PM, Graeme Gregory wrote:
>>> On 28/02/13 08:52, Laxman Dewangan wrote:
>>>> On Thursday 28 February 2013 12:02 AM, Stephen Warren wrote:
>>>>> On 02/17/2013 10:11 PM, J Keerthy wrote:
>>>>> +- interrupt-parent : The parent interrupt controller.
>>>>> +
>>>>> +Optional node:
>>>>> +- Child nodes contain in the palmas. The palmas family is made of
>>>>> several
>>>>> +  variants that support a different number of features.
>>>>> +  The child nodes will thus depend of the capability of the variant.
>>>>> Are there DT bindings for those child nodes anywhere?
>>>>>
>>>>> Representing each internal component as a separate DT node feels a
>>>>> little like designing the DT bindings to model the Linux-internal MFD
>>>>> structure. DT bindings should be driven by the HW design and
>>>>> OS-agnostic.
>>>>>
>>>>>   From a DT perspective, is there any need at all to create a
>>>>> separate DT
>>>>> node for each component? This would only be needed or useful if the
>>>>> child IP blocks (and hence DT bindings for those blocks) could be
>>>>> re-used in other top-level devices that aren't represented by this
>>>>> top-level ti,palmas DT binding. Are the HW IP blocks here re-used
>>>>> anywhere, or will they be?
>>>> I dont think that child IP block can be used outside of the palma
>>>> although other mfd device may have same IP.
>>>>
>>>> The child driver very much used the palma's API for register access
>>>> and they can not be separated untill driver is write completely
>>>> independent of palmas API. Currently, child driver include the palma
>>>> header, uses palma mfd stcruture and plama's api for accessing
>>>> registers.
>>>>
>>> I wonder why break good software principles of keeping data and code
>>> localised? Just because there is no current case where a block is
>>> re-used does not mean it shall not be so in the future. The original
>>> information I got from TI when designing this was blocks may be re-used
>>> in future products.
>>>
>>> This structure also makes it much neater when dealing with palmas
>>> varients with different IP blocks which already exist.
>>>
>>> I also do not see an issue with working like the internal MFD structure,
>>> I think it is a good design.
>>
>> I did not get how the register access will be happen from IP driver.
>> suppose we have RTC driver which is common IP for device 1 and
>> device2. Device1 and device2 are registered as separate MFD driver
>> which has different set of chip structure and initialisation.
>>
>> When I write the RTC register then how do  I call register access?
>> Currently RTC driver is saying device1_reg_read() or
>> device2_reg_read() etc on which register address passed along with dev
>> or chip structure.
>>
> Since I originally wrote the driver it is now possible to get your
> parents regmap without knowledge of the parent.
>
> All that is then needed is a method to pass an offset (possibly re-use
> IO_RESOURCE).
>
> The final but of information that would be needed is some method to pass
> down product_id/design_rev and for a lot of the IP blocks they could be
> made independent of the actual parent.
>
> This is theoretical at the moment because I would not do this work
> unless it became neccessary. But this was in my head when I was
> originally designing the driver.
>
> The RTC is a good point, the same RTC IP block is used in most tps6591X
> and tps800XX devices. My dream would be to make them all one driver!
>
And on the OS agnostic side of things, if you use hierarchies in DT then
the OS does not have to choose to use them.

But if you make everything flat the OS is pretty much forced to follow.

So in my mind trying to make everything flat leads to less choice for
the implementer which is bad IMHO!

Graeme
 

