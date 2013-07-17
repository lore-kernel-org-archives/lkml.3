Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab3GQSDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:03:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:48014 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067Ab3GQSDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:03:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,686,1367996400"; 
   d="scan'208";a="371924800"
Message-ID: <51E6DDE8.1080700@linux.intel.com>
Date: Wed, 17 Jul 2013 11:09:44 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: driver model, duplicate names question
References: <51E57631.2030805@linux.intel.com> <20130716164459.GB17827@kroah.com> <51E59116.2060801@linux.intel.com> <20130716183149.GA6164@kroah.com> <51E596E7.5040504@linux.intel.com> <20130716190422.GA1186@kroah.com> <51E59FEF.90404@linux.intel.com> <20130716193235.GA8142@kroah.com>
In-Reply-To: <20130716193235.GA8142@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 12:32 PM, Greg KH wrote:
> On Tue, Jul 16, 2013 at 12:33:03PM -0700, Srinivas Pandruvada wrote:
>>>> +Example Sys-FS Interface
>>>> +
>>>> +/sys/class/power_cap/intel-rapl
>>>> +├── package-0
>>>> +│   ├── constraint-0
>>>> +│   │   ├── name
>>>> +│   │   ├── power_limit_uw
>>>> +│   │   └── time_window_us
>>>> +│   ├── constraint-1
>>>> +│   │   ├── name
>>>> +│   │   ├── power_limit_uw
>>>> +│   │   └── time_window_us
>>>> +│   ├── core
>>>> +│   │   ├── constraint-0
>>>> +│   │   │   ├── name
>>>> +│   │   │   ├── power_limit_uw
>>>> +│   │   │   └── time_window_us
>>>> +│   │   ├── energy_uj
>>>> +│   │   └── max_energy_range_uj
>>>> +│   ├── dram
>>>> +│   │   ├── constraint-0
>>>> +│   │   │   ├── name
>>>> +│   │   │   ├── power_limit_uw
>>>> +│   │   │   └── time_window_us
>>>> +│   │   ├── energy_uj
>>>> +│   │   └── max_energy_range_uj
>>>> +│   ├── energy_uj
>>>> +│   ├── max_energy_range_uj
>>>> +│   └── max_power_range_uw
>>>> +├── package-1
>>>> +│   ├── constraint-0
>>>> +│   │   ├── name
>>>> +│   │   ├── power_limit_uw
>>>> +│   │   └── time_window_us
>>>> +│   ├── constraint-1
>>>> +│   │   ├── name
>>>> +│   │   ├── power_limit_uw
>>>> +│   │   └── time_window_us
>>>> +│   ├── core
>>>> +│   │   ├── constraint-0
>>>> +│   │   │   ├── name
>>>> +│   │   │   ├── power_limit_uw
>>>> +│   │   │   └── time_window_us
>>>> +│   │   ├── energy_uj
>>>> +│   │   └── max_energy_range_uj
>>>> +│   ├── dram
>>>> +│   │   ├── constraint-0
>>>> +│   │   │   ├── name
>>>> +│   │   │   ├── power_limit_uw
>>>> +│   │   │   └── time_window_us
>>>> +│   │   ├── energy_uj
>>>> +│   │   └── max_energy_range_uj
>>>> +│   ├── energy_uj
>>>> +│   ├── max_energy_range_uj
>>>> +│   └── max_power_range_uw
>>>> +├── power
>>>> +│   ├── async
>>>> +│   ├── autosuspend_delay_ms
>>>> +│   ├── control
>>>> +│   ├── runtime_active_kids
>>>> +│   ├── runtime_active_time
>>>> +│   ├── runtime_enabled
>>>> +│   ├── runtime_status
>>>> +│   ├── runtime_suspended_time
>>>> +│   └── runtime_usage
>>>> +├── subsystem -> ../../../../class/power_cap
>>>> +└── uevent
>>> Ick.  Rewrite this to use a bus and you should be fine, right?  Don't
>>> use a class, a class is only to be used if you have a device that is a
>>> specific "type of thing".  Like a tty device, it is a class, as lots of
>>> different "real" devices can have tty ports on them (usb, pci, pcmcia,
>>> platform, etc.)
>>>
>>> Rethink this using a bus and see if that solves your issues.  You get a
>>> hierarchy with that.  And you can have different "types" of devices on
>>> your bus, making it easy to tell the difference between a "package" and
>>> a "constraint".
>>>
>>> Does that help?
>> I will experiment your suggestion. I see this class analogous to
>> "/sys/class/thermal",
>> , where the thermal class provides a set of consistent interface for all
>> thermal devices.
> But thermal devices are not "real" at all.  There are just a number of
> "cooling devices" on a virtual bus and not attached to any type of a
> real device at all.
>
> There's also no hierarchy that I can see with the thermal class, but you
> want to have this, so you will have to do something different because
> classes do not have hierarchies.
>
> So try using a device and a bus and see if that helps out.  If not,
> please let me know.
Experimented by using a device and a bus. As your initial mail pointed 
out, it still fails.
It will try to create symlink to /sys/bus/BUSTYPE/devices/, which will 
prevent duplicate names.
Someone suggested to do like usb by creating file system entries, which 
will require me to
wear a body armour to post upstream for review.

So I think the solution is to use prevent duplicate names. So in the 
above example of sys-fs:

"package-0" may be called power_zone#, with attribute "name" = 
"package_0". Its children can
be called power_zone#:#. I will still use parent child relationships 
during device_register.
For constraints, I will be using attributes like constraint_0_name, 
constraint_0_power_limit etc. under each power_zone.
Hope this is an acceptable solution.
> thanks,
>
> greg k-h
>

