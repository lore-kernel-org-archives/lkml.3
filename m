Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3G0H0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 03:26:48 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9644 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab3G0H0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 03:26:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 27 Jul 2013 00:25:25 -0700
Message-ID: <51F378E4.8010109@nvidia.com>
Date: Sat, 27 Jul 2013 13:08:12 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH] drivers/rtc/rtc-palmas.c: support for backup battery
 charging
References: <1374755343-32573-1-git-send-email-ldewangan@nvidia.com> <51F2985F.60202@wwwdotorg.org> <28643641.Vi84qGI4SB@flatron>
In-Reply-To: <28643641.Vi84qGI4SB@flatron>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 July 2013 02:15 AM, Tomasz Figa wrote:
> On Friday 26 of July 2013 09:40:15 Stephen Warren wrote:
>> (CC'ing the new DT binding maintainers and mailing list on this reply,
>> hence quoting the whole of the DT binding)
>>
>> On 07/25/2013 06:29 AM, Laxman Dewangan wrote:
>>> Palmas series device like TPS65913, TPS80036 supports the backup
>>> battery for powering the RTC when no other energy source is
>>> available.
>>>
>>> The backup battery is optional, connected to the VBACKUP pin, and can
>>> be nonrechargeable or rechargeable. The rechargeable battery can be
>>> charged from the system supply using the backup battery charger.
>>>
>>> Add support for enabling charging of this backup battery.  Also add
>>> the DT binding document and the new properties to have this support.
>>>
>>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>>> ---
>>>
>>>   .../devicetree/bindings/rtc/rtc-palmas.txt         |   28
>>>   ++++++++++++++ drivers/rtc/rtc-palmas.c                           |
>>>    39 ++++++++++++++++++++ 2 files changed, 67 insertions(+), 0
>>>   deletions(-)
>>>   create mode 100644
>>>   Documentation/devicetree/bindings/rtc/rtc-palmas.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
>>> b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt new file mode
>>> 100644
>>> index 0000000..e4b6910
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
>>> @@ -0,0 +1,28 @@
>>> +Palmas RTC controller bindings
>>> +
>>> +Required properties:
>>> +- compatible:
>>> +  - "ti,palams-rtc" for palma series of the RTC controller
>>> +- interrupt-parent: Parent interrupt device, must be handle of palams
>>> node. +- interrupts: Interrupt number of RTC submodule on device.
>>> +
>>> +Optional properties:
>>> +- ti,back-bat-chg-enable: The palmas series device like TPS65913 or
>>> TPS80036 +	supports the battery backup for powering the RTC when main
>>> battery is +	removed or in very low power state. This flag will
>>> enable the backup +	battery charging.
>>> +- ti,back-bat-chg-current: Configure charging current. Device
>>> supports the +	charging current as < 100mA or >100mA.
>> Does the HW support just two options; less-than or greater-than 100mA?
>> If so, a Boolean property here might be better. The code below certainly
>> implies this.


Yes, it supports the two option, less than 100ma and 100ma. I will 
change it to bool.


>>
>> Given there's only 1 battery, I think "back-" is redundant in the
>> property names. Since that shortens the names a bit, I'd suggest
>> spelling everything out in full, perhaps:
>>
>> battery-charge-enable
>> battery-charge-low-current
> First of all, are those even properties for the RTC binding? Doesn't this
> PMIC contain a charger part which handles battery charging and so requires
> such kind of information?

There is two appropriate place for enabling battery backup charging 
which I can think of, one is in core and other is in RTC driver.
I do not want to new driver for enabling charging as the charger driver. 
There is separate charger module on one of palma device which need full 
flashed driver.
As this backup battery provides power to the RTC only in absence of main 
energy source, I thought of putting this on RTC.

There is no issue to put this piece of code on other palma driver.


