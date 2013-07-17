Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3GQG23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 02:28:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8524 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3GQG22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 02:28:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 16 Jul 2013 23:25:52 -0700
Message-ID: <51E6392E.5080906@nvidia.com>
Date: Wed, 17 Jul 2013 14:26:54 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common codes
References: <1373615287-18502-1-git-send-email-wni@nvidia.com> <1373615287-18502-2-git-send-email-wni@nvidia.com> <20130712152615.23464a6b@endymion.delvare> <20130712135000.GA3386@roeck-us.net> <20130712163034.1fc1cd66@endymion.delvare> <20130712144011.GC3629@roeck-us.net> <51E395D9.6070000@nvidia.com> <20130715092415.6d082aa2@endymion.delvare> <20130717042618.GA11359@mithrandir> <20130717051409.GA16413@roeck-us.net>
In-Reply-To: <20130717051409.GA16413@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 01:14 PM, Guenter Roeck wrote:
> On Wed, Jul 17, 2013 at 06:26:20AM +0200, Thierry Reding wrote:
>> On Mon, Jul 15, 2013 at 09:24:15AM +0200, Jean Delvare wrote:
>>> On Mon, 15 Jul 2013 14:25:29 +0800, Wei Ni wrote:
>>>> On 07/12/2013 10:40 PM, Guenter Roeck wrote:
>>>>> On Fri, Jul 12, 2013 at 04:30:34PM +0200, Jean Delvare wrote:
>>>>>> If that means that for example the ACPI thermal zone is no longer
>>>>>> displayed by "sensors", then I strongly object - unless it is
>>>>>> explicitly registered as a separate hwmon device from now on, of course.
>>>>>
>>>>> If I recall correctly that was the idea. Of course, in practice that will mean
>>>>> that devices will _not_ get exposed as hwmon devices, as implementers won't
>>>>> bother doing both.
>>>>>
>>>>>> My idea was to make the bridge optional - you decide when you register
>>>>>> a thermal device if it should be exposed as hwmon or not.
>>>>>
>>>>> Yes, that would be a much better solution.
>>>>
>>>> I think we can decide it in the DT, we can add a dt property in the lm90
>>>> device node, such as:
>>>> sys-interface = SYS_HWMON;
>>>> or
>>>> sys-interface = SYS_THERMAL;
>>>> So we register it as the hwmon or thermal device
>>>
>>> This is an option, but please keep in mind that DT is not the only way
>>> to instantiate LM90-like devices, and we should not expose duplicate
>>> inputs by default. It is fine with me if the default is to create only a
>>> HWMON device (as the lm90 driver was doing so far), and only
>>> DT-instantiated devices have the choice.
>>
>> I don't think this information belongs in the device tree. Whether the
>> device is exposed as hwmon or thermal device (or both) is entirely a
>> software issue whereas DT is a means to describe the hardware.
>>
> Correct; this is exactly the type of information which does _not_ belong int
> devicetree.
> 
>> It seems to me that the earlier proposal of communicating to the bridge
>> whether or not a device should be exposed as hwmon device is the right
>> thing to do here.
>>
> Agreed..

Sorry, what's the "bridge" mean, does it mean we need to add a flag in
the thermal_zone_device_register() to indicate if we want to register
virtual hwmon device or not?

Thanks.
Wei.

> 
> Guenter
> 

