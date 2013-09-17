Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3IQH70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:59:26 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35398 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3IQH7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:59:22 -0400
Message-ID: <52380BD5.8080105@gmail.com>
Date: Tue, 17 Sep 2013 09:59:17 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Guenter Roeck <linux@roeck-us.net>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Hyun Kwon <hyunk@xilinx.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH] clk: si570: Add a driver for SI570 oscillators
References: <1379033737-30015-1-git-send-email-soren.brinkmann@xilinx.com> <1379033737-30015-2-git-send-email-soren.brinkmann@xilinx.com> <52373314.5070806@wwwdotorg.org> <20130916164927.GB21352@roeck-us.net> <5237390E.5070203@wwwdotorg.org> <20130916173540.GA3481@roeck-us.net> <52374FF7.8040604@wwwdotorg.org>
In-Reply-To: <52374FF7.8040604@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 08:37 PM, Stephen Warren wrote:
> On 09/16/2013 11:35 AM, Guenter Roeck wrote:
>> On Mon, Sep 16, 2013 at 10:59:58AM -0600, Stephen Warren wrote:
>>> On 09/16/2013 10:49 AM, Guenter Roeck wrote:
>>>> On Mon, Sep 16, 2013 at 10:34:28AM -0600, Stephen Warren wrote:
>>>>> On 09/12/2013 06:55 PM, Soren Brinkmann wrote:
>>>>>> Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
>>>>>> The devices generate low-jitter clock signals and are reprogrammable via
>>>>>> an I2C interface.
> ...
>>>>>> +Optional properties:
>>>>>> + - initial-fout: Initial output frequency to set during probe
>>>>>
>>>>> "probe" is a Linux-specific concept. This property should be removed. If
>>>>> the driver is asked to set a specific frequency, it should do so, but I
>>>>> don't think it should program something pro-actively just because it
>>>>> starts up.
>>>>>
>>>>> If this property is acceptable, it'd be better to describe it more along
>>>>> the lines of the following:
>>>>>
>>>>> initial-fout: The frequency at which the system requires the clock to
>>>>> operate.
>>>>
>>>> It should probably be something like "clock-frequency". In many use cases
>>>> the programmed frequency is set to a constant frequency at system startup
>>>> and never changed, similar to other clocks.
>>>
>>> I was going to suggest that too, but re-considered since I think
>>> clock-frequency is more appropriate for fixed-frequency clocks, rather
>>> than to specify the value at which a programmable clock generator should
>>> operate?
>>>
>>> I don't think we have a good story yet for how to represent
>>> how-we-want-the-clock-tree-configured, as opposed to representing the HW
>>> itself (which is what DT should be more about).
>>
>> In many cases the chip _is_ used to generate a fixed frequency, so we will
>> have to have a means to describe it. That it _can_ be used differently is a
>> different matter. After all, that is true for many clock generators.
>
> Perhaps if clock-frequency is specified, the driver should refuse to
> provide anything else. If clock-frequency isn't specified, the driver
> shouldn't touch the HW when it initializes, but should honor any
> requests that come in from other drivers? That would maintain what I
> feel is clock-frequency's connection to being a fixed clock.

For the clk-si5351 programmable clock driver in mainline, it already
uses "clock-frequency" for initial clock setup but allows to set it
later on. IMHO that is ok, because from a initial point-of-view, an
initial frequency is fixed. As soon as the driver takes over, the user
is free to do whatever he wants and should not be limited by DT.

But if we vote against that approach, we should probably also modifiy
clk-si5351 accordingly.

Sebastian
