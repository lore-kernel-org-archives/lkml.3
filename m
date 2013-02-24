Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab3BXRDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 12:03:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab3BXRDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 12:03:43 -0500
Message-ID: <512A47C5.3010500@redhat.com>
Date: Sun, 24 Feb 2013 12:03:01 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>
CC: John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [RFE PATCH 2/2] rtc, add write functionality to sysfs
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-3-git-send-email-prarit@redhat.com> <5127D884.6020701@linaro.org> <5127DB2B.3030700@redhat.com> <5127DDAF.2000403@linaro.org> <B22B05C4-B8D2-44B9-971B-37913DE59EF6@towertech.it>
In-Reply-To: <B22B05C4-B8D2-44B9-971B-37913DE59EF6@towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/23/2013 06:11 PM, Alessandro Zummo wrote:
> On 22/feb/2013, at 22:05, John Stultz <john.stultz@linaro.org> wrote:
> 
>> On 02/22/2013 12:55 PM, Prarit Bhargava wrote:
>>>
>>> On 02/22/2013 03:43 PM, John Stultz wrote:
>>>> On 02/14/2013 09:02 AM, Prarit Bhargava wrote:
>>>>> /sys/class/rtc/rtcX/date and /sys/class/rtc/rtcX/time currently have
>>>>> read-only access.  This patch introduces write functionality which will
>>>>> set the rtc time.
>>>>>
>>>>> Usage: echo YYYY-MM-DD > /sys/class/rtc/rtcX/date
>>>>>         echo HH:MM:SS > /sys/class/rtc/rtcX/time
>>>> Why do we want to add a new interface here?
>>> John,
>>>
>>> I'm not adding a new interface.  The current date/time interface only handles
>>> read and I'm introducing write.
>>>
>>
>> Right, but what benefit does that provide?
>> (I'm not saying there isn't any, its just not clear from your patch why this is a good thing.)
>>

Sorry John, I misunderstood your question.

>> Also CC'ing Alessandro for his input.
> 
> I'd like to keep the interfaces as simple as possible but I'm open to improvements if there are good use cases.
> 

AFAICT there is no way for me to "test" or use the write from userspace.
hwclock uses the SET_TIME ioctl, which is a different code path AFAICT.

I'd like to be at least able to test this stuff when we make changes to it so I
think having write functionality for date & time is worthwhile.

For me, I'm using these to heavily test ntp and ntpdate over system reboots.

OOC, Alessandro, why is the date & time split into two fields?

P.
