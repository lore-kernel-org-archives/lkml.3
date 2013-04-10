Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936847Ab3DJLEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:04:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51557 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3DJLEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:04:52 -0400
Message-ID: <51654741.30206@ti.com>
Date: Wed, 10 Apr 2013 14:04:33 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <grygorii.strashko@ti.com>,
        <linux@arm.linux.org.uk>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for
 AUXCLKs
References: <1363703220-4777-2-git-send-email-rogerq@ti.com> <20130403234242.GE10155@atomide.com> <515D2D30.3000306@ti.com> <20130404164137.GH10155@atomide.com> <515EA9E3.1010409@ti.com> <20130405155851.GA10155@atomide.com> <5163E589.1040809@ti.com> <20130409164928.GL10155@atomide.com> <20130409174319.GP10155@atomide.com> <20130409204900.GA8815@kahuna> <20130409215419.GA13731@kahuna>
In-Reply-To: <20130409215419.GA13731@kahuna>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 12:54 AM, Nishanth Menon wrote:
> On 15:49-20130409, Nishanth Menon wrote:
>> On 10:43-20130409, Tony Lindgren wrote:
>>> * Tony Lindgren <tony@atomide.com> [130409 09:54]:
>>>> * Roger Quadros <rogerq@ti.com> [130409 03:00]:
>>>>> On 04/05/2013 06:58 PM, Tony Lindgren wrote:
>>>>>>
>>>>>> Can't you just use the clock name there to get it?
>>>>>
>>>>> In device tree we don't pass around clock names. You can either get
>>>>> a phandle or an index to the clock.
>>>>>
>>>>> e.g. Documentation/devicetree/bindings/clock/imx31-clock.txt
>>>>
>>>> Yes I understand that. But the driver/clock/omap driver can just
>>>> remap the DT device initially so the board specific clock is
>>>> found from the clock alias table. Basically initially a passthrough
>>>> driver that can be enhanced to parse DT clock bindings and load
>>>> data from /lib/firmware.
>>>
>>> Actually probably the driver/clock/omap can even do even less
>>> initially. There probably even no need to remap clocks there.
>>>
>>> As long as the DT clock driver understands that a board specific
>>> auxclk is specified in the DT it can just call clk_add_alias() so
>>> the driver will get the right auxclk from cclock44xx_data.c.
>>>
>>> Then other features can be added later on like to allocate a
>>> clock entirely based on the binding etc.
>> I did try to have an implementation for cpufreq using clock nodes.
>> unfortunately, device tree wont let me have arguments of strings :(
>> So, I am unable to do clock = <&clk mpu_dpll>;
>> instead, I am forced to do clock = <&clk 249>;
>>
>> Here is an attempt on beagleXM - adds every clock node to the list.
>> Tons of un-necessary prints added to give an idea - see log:
>> http://pastebin.com/F9A2zSTr
>>
>> Would an cleaned up version be good enough as a step #1 of transition?
>>
> Approach #2:
> Here is yet another revision -> here I am trying to avoid the risk of
> folks messing up indexing. for example: using an older DTB with newer
> kernel, clocks being inserted into existing list etc. to prevent these,

Why do you need to worry about users using old DTB with new kernel.
That is entirely the user's fault no?

> we add an "DT_ID" for omap clock nodes, and use it to uniquely identify
> the clock node. We try to minimize(not avoidable with integer indexing)
> mistakes during development/productization.

cheers,
-roger
