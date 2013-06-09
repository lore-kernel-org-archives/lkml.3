Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab3FIIQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 04:16:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:13291 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab3FIIQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 04:16:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,830,1363158000"; 
   d="scan'208";a="326530207"
Message-ID: <51B4389E.8050501@intel.com>
Date: Sun, 09 Jun 2013 16:11:10 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: yanmin_zhang@linux.intel.com, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, pavel@ucw.cz,
        len.brown@intel.com
Subject: Re: [PATCH 0/2] Run callback of device_prepare/complete consistently
References: <1370593232-3602-1-git-send-email-shuox.liu@intel.com> <2994160.MkjLhsn0bK@vostro.rjw.lan> <1370659038.4432.112.camel@ymzhang.sh.intel.com> <1848832.IkLoHNGzvs@vostro.rjw.lan>
In-Reply-To: <1848832.IkLoHNGzvs@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-06-08 18:54, Rafael J. Wysocki wrote:

> On Saturday, June 08, 2013 10:37:18 AM Yanmin Zhang wrote:
>> On Sat, 2013-06-08 at 03:52 +0200, Rafael J. Wysocki wrote:
>>> On Saturday, June 08, 2013 09:36:03 AM Yanmin Zhang wrote:
>>>> On Sat, 2013-06-08 at 03:30 +0200, Rafael J. Wysocki wrote:
>>>>> On Friday, June 07, 2013 06:16:25 PM Greg KH wrote:
>>>>>> On Sat, Jun 08, 2013 at 08:42:12AM +0800, Yanmin Zhang wrote:
>>>>>>> On Fri, 2013-06-07 at 12:36 +0200, Rafael J. Wysocki wrote:
>>>>>>>> On Friday, June 07, 2013 04:20:30 PM shuox.liu@intel.com wrote:
>>>>>>>>> dpm_run_callback is used in other stages of power states changing.
>>>>>>>>> It provides debug info message and time measurement when call these
>>>>>>>>> callback. We also want to benefit ->prepare and ->complete.
>>>>>>>>>
>>>>>>>>> [PATCH 1/2] PM: use dpm_run_callback in device_prepare
>>>>>>>>> [PATCH 2/2] PM: add dpm_run_callback_void and use it in device_complete
>>>>>>>>
>>>>>>>> Is this an "Oh, why don't we do that?" series, or is it useful for anything
>>>>>>>> in practice?  I'm asking, because we haven't added that stuff to start with
>>>>>>>> since we didn't see why it would be useful to anyone.
>>>>>>>>
>>>>>>>> And while patch [1/2] reduces the code size (by 1 line), so I can see some
>>>>>>>> (tiny) benefit from applying it, patch [2/2] adds more code and is there any
>>>>>>>> paractical reason?
>>>>>>> Sometimes, suspend-to-ram path spends too much time (either suspend slowly
>>>>>>> or wakeup slowly) and we need optimize it.
>>>>>>> With the 2 patches, we could collect initcall_debug printk info and manually
>>>>>>> check what prepare/complete callbacks consume too much time.
>>>>>>
>>>>>> But initcall information is for initialization stuff, not suspend/resume
>>>>>> things, right?  Doesn't the existing tools for parsing this choke if it
>>>>>> sees the information at suspend/resume time?
>>>>>
>>>>> We've been using that for suspend/resume for quite some time too, but not
>>>>> for the prepare/complete phases (because we still believe that's not really
>>>>> useful for them). 
>>>>>
>>>>> Well, I'll be handling patches changing code under drivers/base/power,
>>>>> I promise. :-)
>>>>>
>>>>> I've been doing that for quite a few years now ...
>>>> Yes, indeed. Power is one of the most important features on embedded devices.
>>>> Lots of smart phones don't really go through the full cycles of suspend-to-ram.
>>>> We are following the full steps of the suspend.
>>>
>>> But if you go through the code, you'll see that alomost no drivers actually
>>> implemet .prepare() and .complete().  Some subsystems do, but they really don't
>>> take too much time to execute.  Which means that your patches with
>>> initcall_debug will add quite a pile of useless garbage to the kernel log
>> Does that mean we need add more log levels around such info instead of just having or
>> not having?
> 
> Since we don't have any code in the tree that causes problems those patches are
> supposed to catch, I don't see why we need them in the tree.  Would it be
> viable to keep them out of the tree for the time being and re-submit once
> there is real need?

It's OK with me. I will keep them in my debug tree.
Thanks all.

Shuo
