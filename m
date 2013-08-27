Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3H0Va2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:30:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36537 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab3H0VaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:30:23 -0400
Message-ID: <521D1A6A.8040001@wwwdotorg.org>
Date: Tue, 27 Aug 2013 15:30:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/3] pinctrl: at91: add support for generic pinconf
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com> <1377380259-11290-1-git-send-email-b.brezillon@overkiz.com> <20130826175333.GF18627@ns203013.ovh.net> <521BA235.1090104@overkiz.com> <521C22EA.1050908@wwwdotorg.org> <521C4177.4030104@overkiz.com>
In-Reply-To: <521C4177.4030104@overkiz.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 12:04 AM, boris brezillon wrote:
> On 27/08/2013 05:54, Stephen Warren wrote:
>> On 08/26/2013 12:45 PM, boris brezillon wrote:
>>> Hello Jean-Christophe,
>>>
>>> Le 26/08/2013 19:53, Jean-Christophe PLAGNIOL-VILLARD a écrit :
>>>> On 23:37 Sat 24 Aug     , Boris BREZILLON wrote:
>>>>> Add support for generic pin configuration to pinctrl-at91 driver.
>> ...
>>>>> a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>> ...
>>>>> configures various pad settings
>>>>>    such as pull-up, multi drive, etc.
>>>>>      Required properties for iomux controller:
>>>>> -- compatible: "atmel,at91rm9200-pinctrl"
>>>>> +- compatible: "atmel,at91rm9200-pinctrl" or
>>>>> "atmel,at91sam9x5-pinctrl".
>>>>> +  Add "generic-pinconf" to the compatible string list to use the
>>>>> generic pin
>> ...
>>>>> +pinctrl@fffff400 {
>>>>> +    #address-cells = <1>;
>>>>> +    #size-cells = <1>;
>>>>> +    ranges;
>>>>> +    compatible = "atmel,at91rm9200-pinctrl", "generic-pinconf",
>>>>> "simple-bus";
>>>> nack your break the backword compatibility
>>>>
>>>> if we use a old kernel with this new dt nothing will work
>>>> as the old kernel will never known the the "generic-pinconf" means
>>>> anything
>>> Your're right, I didn't think of this case (old kernel with new dt).
>> Well, just to be clear: If a new DT uses a new compatible value of any
>> kind, be it adding "generic-pinconf" or switching to "foo-yyy" rather
>> than "foo-yyy", it won't be compatible... That somewhat implies that you
>> can't ever replace an old binding with something new.
> 
> That's absolutely right, however the behaviour won't be the same in both
> cases.
> 
> 1) If your (new) dt defines its pinctrl using the "foo-pinconf"
> compatible string and
>     your (old) kernel does not support it, the pinctrl will never probe
> the pinctrl definitions.

True.

>     Moreover, if you want to define both old ("foo-pinctrl") and new
> ("foo-pinconf") pinctrl
>     definitions in your dt in order to support several kernel versions,
> nothing prevents you
>     from doing it.

I don't know if that will work well; what happens if a kernel supports
both the old and new compatible values, so that the new kernel is
compatible with old DTs?

> 2) In the other hand, if you use an additional "generic-pinconf"
> compatible string to signify
>     wether or not the pinctrl definition use the generic pinconf dt
> binding, the (old) kernel
>     will probe the pinctrl definitions, ignore the "generic-pinconf"
> string, and fail when parsing
>     the pinctrl configuration nodes (which are invalid pinctrl function
> nodes in the current dt binding).
>     We have the same problem when using the 'atmel,generic-pinconf'
> property inside a pinctrl node:
>     old kernels won't take this property into account.

True.

