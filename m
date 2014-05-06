Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaEFNcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:32:24 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51614 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaEFNcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:32:22 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5368E45F.30301@roeck-us.net>
Date: Tue, 06 May 2014 06:32:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] coretemp.0 folder contents changed
References: <5367C6A7.5020008@linux.intel.com>	<20140505173231.GA25644@roeck-us.net> <20140506135558.3cafd062@endymion.delvare>
In-Reply-To: <20140506135558.3cafd062@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 04:55 AM, Jean Delvare wrote:
> Hi Guenter, Srinivas,
>
> On Mon, 5 May 2014 10:32:31 -0700, Guenter Roeck wrote:
>> On Mon, May 05, 2014 at 10:13:11AM -0700, Srinivas Pandruvada wrote:
>>> for kernel : 3.15.rc3 .
>>>
>>> Is there any change in the coretemp? Previously we used to see,
>>> tempx data (like temp2_input, temp2_max etc.)
>>> /sys/devices/platform/coretemp.0/.
>>
>> That isn't where you are supposed to look for hwmon attributes.
>
> Actually I used to recommend looking there when people were not using
> libsensors (e.g. for pwmconfig / fancontrol or custom scripts.) This
> path had the great merit of being stable across reboots, while hwmon
> class device numbers are not (or at least they aren't guaranteed to be.)
>
>> (...)
>> To give you the background, hwmon attributes are in the process of
>> being moved from the parent device to the hwmon device, or from
>> /sys/class/hwmon/hwmonX/device/ to /sys/class/hwmon/hwmonX/,
>> as part of an effort to streamline the code and make it more
>> consistent and maintainable.
>
> I am just realizing that we are also losing the stability of hardware
> device based paths with that move :( I suppose I shouldn't have
> bothered adding support for this to fancontrol.
>
> Don't get me wrong, I still believe this is the right move, but I fear
> that the question of persistent hwmon device names will resurface every
> now and then again. libsensors offers a solution but 1* it lacks
> support for pwm attributes and 2* it doesn't help with shell or perl
> scripts such as pwmconfig and fancontrol.
>
Can we implement a similar approach to network devices and make hwmon
path names (ie the /sys/class/hwmon/XXX path name) configurable via udev ?
Might be worth exploring.

Guenter

