Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3GOG1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:27:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17119 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab3GOG1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:27:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 14 Jul 2013 23:25:22 -0700
Message-ID: <51E395D9.6070000@nvidia.com>
Date: Mon, 15 Jul 2013 14:25:29 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, <rui.zhang@intel.com>,
        Jean Delvare <khali@linux-fr.org>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common codes
References: <1373615287-18502-1-git-send-email-wni@nvidia.com> <1373615287-18502-2-git-send-email-wni@nvidia.com> <20130712152615.23464a6b@endymion.delvare> <20130712135000.GA3386@roeck-us.net> <20130712163034.1fc1cd66@endymion.delvare> <20130712144011.GC3629@roeck-us.net>
In-Reply-To: <20130712144011.GC3629@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 10:40 PM, Guenter Roeck wrote:
> On Fri, Jul 12, 2013 at 04:30:34PM +0200, Jean Delvare wrote:
>> Hi Guenter,
>>
>> On Fri, 12 Jul 2013 06:50:00 -0700, Guenter Roeck wrote:
>>> On Fri, Jul 12, 2013 at 03:26:15PM +0200, Jean Delvare wrote:
>>>> One thing I am a little worried about (but maybe I'm wrong) is that I
>>>> seem to understand you want to register every LM90-like chip as both a
>>>> hwmon device and two thermal devices. I seem to recall that every
>>>> thermal device is also exposed automatically as a virtual hwmon
>>>> device, is that correct? If so we will be presenting the same values
>>>> twice to libsensors, which would be confusing.
>>>
>>> Not sure if that is a good idea, but if I recall correctly, the thermal folks
>>> plan to remove that path.

Hi, Rui
As Jean said, if we want to register the lm90 as thermal device, it will
have two hwmon devices in the sysfs, one is registered by the lm90
driver, another one is registered by the thermal_zone_device_register(),
this would be confusing.

Do you have any ideas for it?

Thanks.
Wei.

>>
>> If that means that for example the ACPI thermal zone is no longer
>> displayed by "sensors", then I strongly object - unless it is
>> explicitly registered as a separate hwmon device from now on, of course.
>>
> If I recall correctly that was the idea. Of course, in practice that will mean
> that devices will _not_ get exposed as hwmon devices, as implementers won't
> bother doing both.
> 
>> My idea was to make the bridge optional - you decide when you register
>> a thermal device if it should be exposed as hwmon or not.
>>
> Yes, that would be a much better solution.

I think we can decide it in the DT, we can add a dt property in the lm90
device node, such as:
sys-interface = SYS_HWMON;
or
sys-interface = SYS_THERMAL;
So we register it as the hwmon or thermal device

> 
>> I don't have a strong opinion on the implementation, as long as each
>> input is listed by "sensors" once and only once.
>>
> Agreed.
> 
> Guenter
> 

