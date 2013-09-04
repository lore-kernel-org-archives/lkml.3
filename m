Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763027Ab3IDQmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:42:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46260 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762953Ab3IDQmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:42:46 -0400
Subject: Re: [PATCH 1/2] hwspinlock/omap: add support for dt nodes
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <52275F7D.4030305@ti.com>
Date: Wed, 4 Sep 2013 11:42:49 -0500
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <9BE41927-7C6C-4E62-860B-0288627E9421@codeaurora.org>
References: <1378230767-54931-1-git-send-email-s-anna@ti.com> <43798031-2D57-44F0-A19C-FD80DB9E9794@codeaurora.org> <52263413.1050108@ti.com> <8E84282E-BAD1-4A2B-849A-167C32F629DA@codeaurora.org> <52266409.90908@ti.com> <71570936-39F5-4AE1-AD05-163EA3179271@codeaurora.org> <52275F7D.4030305@ti.com>
To: Suman Anna <s-anna@ti.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 4, 2013, at 11:27 AM, Suman Anna wrote:

> Kumar,
> 
>>>>>> 
>>>>>>> HwSpinlock IP is present only on OMAP4 and other newer SoCs,
>>>>>>> which are all device-tree boot only. This patch adds the
>>>>>>> base support for parsing the DT nodes, and removes the code
>>>>>>> dealing with the traditional platform device instantiation.
>>>>>>> 
>>>>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>>>>> ---
>>>>>>> .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 28 ++++++++++
>>>>>>> arch/arm/mach-omap2/Makefile                       |  3 --
>>>>>>> arch/arm/mach-omap2/hwspinlock.c                   | 60 ----------------------
>>>>>>> drivers/hwspinlock/omap_hwspinlock.c               | 21 ++++++--
>>>>>>> 4 files changed, 45 insertions(+), 67 deletions(-)
>>>>>>> create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>>>>>>> delete mode 100644 arch/arm/mach-omap2/hwspinlock.c
>>>>>>> 
>>>>>>> diff --git a/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>>>>>>> new file mode 100644
>>>>>>> index 0000000..adfb8ad
>>>>>>> --- /dev/null
>>>>>>> +++ b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>>>>>>> @@ -0,0 +1,28 @@
>>>>>>> +OMAP4+ HwSpinlock Driver
>>>>>>> +
>>>>>>> +Required properties:
>>>>>>> +- compatible:		Currently supports only "ti,omap4-hwspinlock" for
>>>>>>> +				OMAP44xx, OMAP54xx, AM33xx, AM43xx, DRA7xx SoCs
>>>>>>> +- reg:			Contains the hwspinlock register address range (base
>>>>>>> +			address and length)
>>>>>>> +- ti,hwmods:		Name of the hwmod associated with the hwspinlock device
>>>>>>> +
>>>>>>> +Optional properties:
>>>>>>> +- base_id:		Base Id for the locks for a particular hwspinlock
>>>>>>> +			device. If not mentioned, a default value of 0 is used.
>>>>>>> +			This property is mandatory ONLY if a SoC has several
>>>>>>> +			hwspinlock devices. There are currently no such OMAP
>>>>>>> +			SoCs.
>>>>>> 
>>>>>> Should this be ti,base_id ? [ I know its kinda generic in its intent for any SoC w/multiple blocks ]
>>>>> 
>>>>> I didn't add the "ti," prefix exactly for the same reason - it is
>>>>> generic w.r.t the hwspinlock core irrespective of the SoC family, and
>>>>> there is nothing ti or OMAP specific about it. I have added it to keep
>>>>> the DT node definition in sync with the driver code. If it is too
>>>>> generic a name, it can always be renamed as hwlock_base_id. This will be
>>>>> SoC agnostic property for the hwspinlock driver. What do you think?
>>>> 
>>>> I'm wondering if we should use cell-index for this purpose.
>>> 
>>> I didn't get you completely. Do you intend to compute the base_id using
>>> cell-index and number of locks (which may be a separate field altogether
>>> if this information cannot be read from the h/w)? My understanding is
>>> that cell-index is primarily used for identifying the h/w instance number.
>> 
>> I was suggesting using cell-index instead of base_id.  What we should probably due is have a devicetree/bindings/hwlock/hwlock.txt that would describe generic properties like this and just reference that in the omap binding spec.
> 
> Common hwlock.txt sounds good. Will make the change.
> 
>> 
>> I'm thinking if we dont use cell-index, that it should probably be hwlock-base-id
>> 
> 
> I prefer to use hwlock-base-id. I think we should also be defining a
> common property name for number of locks, say hwlock-num-locks.

I'm good with that, cell-index is always funny so might as well be explicit.

I'm also good with hwlock-num-locks, I'll update the msm spinlock driver to use this.

Can you also maybe add some helper functions into the hwspinlock core to return these values so we both don't duplicate code in drivers and maintain consistency.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

