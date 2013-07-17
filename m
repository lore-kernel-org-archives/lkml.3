Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3GQSso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:48:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:25103 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab3GQSsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:48:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,686,1367996400"; 
   d="scan'208";a="347227189"
Message-ID: <51E6E88D.3030107@linux.intel.com>
Date: Wed, 17 Jul 2013 11:55:09 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: driver model, duplicate names question
References: <51E57631.2030805@linux.intel.com> <20130716164459.GB17827@kroah.com> <51E59116.2060801@linux.intel.com> <20130716183149.GA6164@kroah.com> <51E596E7.5040504@linux.intel.com> <20130716190422.GA1186@kroah.com> <51E59FEF.90404@linux.intel.com> <20130716193235.GA8142@kroah.com> <51E6DDE8.1080700@linux.intel.com> <20130717183105.GA14988@kroah.com>
In-Reply-To: <20130717183105.GA14988@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 11:31 AM, Greg KH wrote:
> On Wed, Jul 17, 2013 at 11:09:44AM -0700, Srinivas Pandruvada wrote:
>>> But thermal devices are not "real" at all.  There are just a number of
>>> "cooling devices" on a virtual bus and not attached to any type of a
>>> real device at all.
>>>
>>> There's also no hierarchy that I can see with the thermal class, but you
>>> want to have this, so you will have to do something different because
>>> classes do not have hierarchies.
>>>
>>> So try using a device and a bus and see if that helps out.  If not,
>>> please let me know.
>> Experimented by using a device and a bus. As your initial mail pointed
>> out, it still fails.
>> It will try to create symlink to /sys/bus/BUSTYPE/devices/, which will
>> prevent duplicate names.
> Where are you going to create a symlink from?  That doesn't make sense,
> just use a class if you want a link.
Sorry, my reply may not be clear here. I am not creating any symlinks.
device_register will create a symlink. For example, if I create a bus 
named "test",
with two parents and one child each:
ls -l /sys/bus/test/devices
lrwxrwxrwx 1 root root 0 Jul 17 09:05 child_0 -> 
../../../devices/parent_0/child_0
lrwxrwxrwx 1 root root 0 Jul 17 09:05 child_1 -> 
../../../devices/parent_1/child_1
lrwxrwxrwx 1 root root 0 Jul 17 09:05 parent_0 -> ../../../devices/parent_0
lrwxrwxrwx 1 root root 0 Jul 17 09:05 parent_1 -> ../../../devices/parent_1

>> Someone suggested to do like usb by creating file system entries, which
>> will require me to wear a body armour to post upstream for review.
> So a separate filesystem alltogether?  That would work, but you then
> loose any benifit that the driver core and sysfs provides you, for no
> benifit other than looking at a pretty tree in a filesystem.  I don't
> see the real need for that at all.
>
>> So I think the solution is to use prevent duplicate names. So in the
>> above example of sys-fs:
>>
>> "package-0" may be called power_zone#, with attribute "name" =
>> "package_0". Its children can
>> be called power_zone#:#. I will still use parent child relationships
>> during device_register.
>> For constraints, I will be using attributes like constraint_0_name,
>> constraint_0_power_limit etc. under each power_zone.
>> Hope this is an acceptable solution.
> That's what other busses have used for this very reason :)
>
> Also look at the "type" of device you are creating for your bus, that
> will help you differentiate them from each other instead of having to
> rely on the names of them to determine what is going on within the
> kernel.
<Thanks for your time and help.>
> good luck,
>
> greg k-h
>

