Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295Ab3ICWfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:35:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47488 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760527Ab3ICWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:34:59 -0400
Message-ID: <52266409.90908@ti.com>
Date: Tue, 3 Sep 2013 17:34:49 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] hwspinlock/omap: add support for dt nodes
References: <1378230767-54931-1-git-send-email-s-anna@ti.com> <43798031-2D57-44F0-A19C-FD80DB9E9794@codeaurora.org> <52263413.1050108@ti.com> <8E84282E-BAD1-4A2B-849A-167C32F629DA@codeaurora.org>
In-Reply-To: <8E84282E-BAD1-4A2B-849A-167C32F629DA@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar,

>>
>> On 09/03/2013 01:50 PM, Kumar Gala wrote:
>>>
>>> On Sep 3, 2013, at 12:52 PM, Suman Anna wrote:
>>>
>>>> HwSpinlock IP is present only on OMAP4 and other newer SoCs,
>>>> which are all device-tree boot only. This patch adds the
>>>> base support for parsing the DT nodes, and removes the code
>>>> dealing with the traditional platform device instantiation.
>>>>
>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>> ---
>>>> .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 28 ++++++++++
>>>> arch/arm/mach-omap2/Makefile                       |  3 --
>>>> arch/arm/mach-omap2/hwspinlock.c                   | 60 ----------------------
>>>> drivers/hwspinlock/omap_hwspinlock.c               | 21 ++++++--
>>>> 4 files changed, 45 insertions(+), 67 deletions(-)
>>>> create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>>>> delete mode 100644 arch/arm/mach-omap2/hwspinlock.c
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>>>> new file mode 100644
>>>> index 0000000..adfb8ad
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>>>> @@ -0,0 +1,28 @@
>>>> +OMAP4+ HwSpinlock Driver
>>>> +
>>>> +Required properties:
>>>> +- compatible:		Currently supports only "ti,omap4-hwspinlock" for
>>>> +				OMAP44xx, OMAP54xx, AM33xx, AM43xx, DRA7xx SoCs
>>>> +- reg:			Contains the hwspinlock register address range (base
>>>> +			address and length)
>>>> +- ti,hwmods:		Name of the hwmod associated with the hwspinlock device
>>>> +
>>>> +Optional properties:
>>>> +- base_id:		Base Id for the locks for a particular hwspinlock
>>>> +			device. If not mentioned, a default value of 0 is used.
>>>> +			This property is mandatory ONLY if a SoC has several
>>>> +			hwspinlock devices. There are currently no such OMAP
>>>> +			SoCs.
>>>
>>> Should this be ti,base_id ? [ I know its kinda generic in its intent for any SoC w/multiple blocks ]
>>
>> I didn't add the "ti," prefix exactly for the same reason - it is
>> generic w.r.t the hwspinlock core irrespective of the SoC family, and
>> there is nothing ti or OMAP specific about it. I have added it to keep
>> the DT node definition in sync with the driver code. If it is too
>> generic a name, it can always be renamed as hwlock_base_id. This will be
>> SoC agnostic property for the hwspinlock driver. What do you think?
> 
> I'm wondering if we should use cell-index for this purpose.

I didn't get you completely. Do you intend to compute the base_id using
cell-index and number of locks (which may be a separate field altogether
if this information cannot be read from the h/w)? My understanding is
that cell-index is primarily used for identifying the h/w instance number.

regards
Suman

>>
>>>
>>>> +
>>>> +			See documentation on struct hwspinlock_pdata in
>>>> +			linux/hwspinlock.h for more details.
>>>> +
>>>> +
>>>> +Example:
>>>> +
>>>> +/* OMAP4 */
>>>> +hwspinlock: spinlock@4a0f6000 {
>>>> +	compatible = "ti,omap4-hwspinlock";
>>>> +	reg = <0x4a0f6000 0x1000>;
>>>> +	ti,hwmods = "spinlock";
>>>> +};
>>>
>>> [ snip ]
>>>
>>> - k
>>>
>>
> 

