Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3INIBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 04:01:13 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44090 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3INIBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 04:01:10 -0400
Message-ID: <523417BF.7030505@gmail.com>
Date: Sat, 14 Sep 2013 10:01:03 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Guenter Roeck <linux@roeck-us.net>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Hyun Kwon <hyunk@xilinx.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: si570: Add a driver for SI570 oscillators
References: <1379033737-30015-1-git-send-email-soren.brinkmann@xilinx.com> <1379033737-30015-2-git-send-email-soren.brinkmann@xilinx.com> <20130913170005.GB5681@roeck-us.net> <c6755ff6-104d-40fe-a753-0e165cff1e10@AM1EHSMHS004.ehs.local>
In-Reply-To: <c6755ff6-104d-40fe-a753-0e165cff1e10@AM1EHSMHS004.ehs.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 07:26 PM, Sören Brinkmann wrote:
> On Fri, Sep 13, 2013 at 10:00:05AM -0700, Guenter Roeck wrote:
>> On Thu, Sep 12, 2013 at 05:55:37PM -0700, Soren Brinkmann wrote:
>>> Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
>>> The devices generate low-jitter clock signals and are reprogrammable via
>>> an I2C interface.
>>>
>>> Cc: Guenter Roeck <linux@roeck-us.net>
>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>> ---
[...]
>>> diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
>>> new file mode 100644
>>> index 0000000..960d689
>>> --- /dev/null
>>> +++ b/drivers/clk/clk-si570.c
>>> @@ -0,0 +1,546 @@
[...]
>>> +	match = of_match_node(clk_si570_of_match, client->dev.of_node);
>>> +	if (!match)
>>> +		return -EINVAL;
>>
>> Seems unusual. Is this really needed ? It precludes the driver from being used
>> in a non-devicetree environment, for example. I would guess that there is a match
>> if client->dev.of_node is set. Otherwise, this code would be needed in every
>> driver supporting devicetree, and I don't recall seeing that.
>>
>>> +	ddata = match->data;
>>> +
>> You should be able to get this information (ie the pointer to si570_device_data)
>> from id->driver_data. That would be more consistent with other i2c devices.
> I think I copied this approach from the other clk-si... driver. I'll
> do some research on your suggestion and change it. Could you point me to
> an example for your proposal?

Soeren,

I sent a patch for the match removal in clk-si5351 [1].
Mike must have missed it, I will resend soon.
You can take that as "an example for the proposal" above.

Sebastian

[1] https://lkml.org/lkml/2013/9/3/484

