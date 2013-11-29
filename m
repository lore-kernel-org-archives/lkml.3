Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3K2PJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:09:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36571 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3K2PJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:09:37 -0500
Message-ID: <5298ADD1.7050203@ti.com>
Date: Fri, 29 Nov 2013 10:08:01 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, <gregkh@linuxfoundation.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] memory: ti-aemif: add bindings for AEMIF driver
References: <1384962416-14862-1-git-send-email-ivan.khoronzhuk@ti.com> <1384962416-14862-3-git-send-email-ivan.khoronzhuk@ti.com> <20131120182102.GK14627@ns203013.ovh.net> <528D076A.8070806@ti.com> <20131122184247.GO14627@ns203013.ovh.net> <5298AB08.3090108@ti.com>
In-Reply-To: <5298AB08.3090108@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 November 2013 09:56 AM, Grygorii Strashko wrote:
> Hi Jean-Christophe,
> 
> On 11/22/2013 08:42 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> On 21:03 Wed 20 Nov     , ivan.khoronzhuk wrote:
>>> On 11/20/2013 08:21 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>>> +				the chip select signal.
>>>>> +				Minimum value is 1 (0 treated as 1).
>>>>> +
>>>>> +- ti,cs-wsetup:		write setup width, ns
>>>>> +				Time between the beginning of a memory cycle
>>>>> +				and the activation of write strobe.
>>>>> +				Minimum value is 1 (0 treated as 1).
>>>>> +
>>>>> +- ti,cs-wstrobe:	write strobe width, ns
>>>>> +				Time between the activation and deactivation of
>>>>> +				the write strobe.
>>>>> +				Minimum value is 1 (0 treated as 1).
>>>>> +
>>>>> +- ti,cs-whold:		write hold width, ns
>>>>> +				Time between the deactivation of the write
>>>>> +				strobe and the end of the cycle (which may be
>>>>> +				either an address change or the deactivation of
>>>>> +				the chip select signal.
>>>>> +				Minimum value is 1 (0 treated as 1).
>>>>> +
>>>>> +If any of the above parameters are absent, current parameter value will be taken
>>>>> +from the corresponding HW reg.
>>>>> +
>>>>> +The name for cs node must be in format csN, where N is the cs number.
>>>>
>>>> this is wired we should use reg instead to represent the cs as done for SPI
>>>> or a an other property
>>>>
>>>> Best Regards,
>>>> J.
>>>>
>>>
>>> Ok, I will add new property cs-chipselect like following :
>>>
>>> ti,cs-chipselect:	number of chipselect. Indicates on the
>>> 			aemif driver which chipselect is used
>>> 			for accessing the memory.
>>> 			For compatibles "ti,davinci-aemif" and
>>> 			"ti,keystone-aemif" it can be in range [0-3].
>>> 			For compatible "ti,omap-L138-aemif" range is [2-5].
>>>
>>> Is it OK?
>>
>> yes
>>
>> I just have one issue the whole memory concept
>>
>> for me we should do as done on pinctrl have a phandle on the device that
>> require it and handle it at device core level
>>
>> as the memory controller is not necessarely on the same bus as the memory
>> device them selves
> 
> Could you clarify your point a bit, pls?
> Are you talking about external ASRAM, NOR and NAND chips wired to CS interface?
> 
Thats probably what he means.
The mtd devices can be interface with different memory controllers having different
layouts to set-up timing registers. If these layouts were standard, then it would
have been possible to manage the information at the core layers.

Regards,
Santosh


