Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaEERmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:42:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:6075 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaEERmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:42:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,990,1389772800"; 
   d="scan'208";a="534986184"
Message-ID: <5367CE6F.7010006@linux.intel.com>
Date: Mon, 05 May 2014 10:46:23 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: coretemp.0 folder contents changed
References: <5367C6A7.5020008@linux.intel.com> <20140505173231.GA25644@roeck-us.net>
In-Reply-To: <20140505173231.GA25644@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 10:32 AM, Guenter Roeck wrote:
> On Mon, May 05, 2014 at 10:13:11AM -0700, Srinivas Pandruvada wrote:
>> Hi,
>>
>> for kernel : 3.15.rc3 .
>>
>> Is there any change in the coretemp? Previously we used to see,
>> tempx data (like temp2_input, temp2_max etc.)
>> /sys/devices/platform/coretemp.0/.
>>
> That isn't where you are supposed to look for hwmon attributes.
>
>> Now We don't see them. Now we have to go
>> /sys/devices/platform/coretemp.0/hwmon/hwmon?/ to get these values.
>>
> This is also not the correct location.
>
> You should be looking in /sys/class/hwmon/hwmonX/.
>
> There will be a name attribute either in /sys/class/hwmon/hwmonX/name
> or in /sys/class/hwmon/hwmonX/device/name. For coretemp, the value
> reported in the name attribute will be 'coretemp'. This defines the
> directory where the actual sensor attributes will be located.
>
> A better approach might be to use libsensors instead of directly
> accessing attributes.
>
> To give you the background, hwmon attributes are in the process of
> being moved from the parent device to the hwmon device, or from
> /sys/class/hwmon/hwmonX/device/ to /sys/class/hwmon/hwmonX/,
> as part of an effort to streamline the code and make it more
> consistent and maintainable.
>
> Guenter
>
Thanks for your quick reply.

-Srinivas
