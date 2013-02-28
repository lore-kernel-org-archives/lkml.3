Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab3B1Svh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:51:37 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37708 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab3B1Svf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:51:35 -0500
Message-ID: <512FA732.4010703@linaro.org>
Date: Thu, 28 Feb 2013 10:51:30 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: Alessandro Zummo <a.zummo@towertech.it>,
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
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-3-git-send-email-prarit@redhat.com> <5127D884.6020701@linaro.org> <5127DB2B.3030700@redhat.com> <5127DDAF.2000403@linaro.org> <B22B05C4-B8D2-44B9-971B-37913DE59EF6@towertech.it> <512A47C5.3010500@redhat.com>
In-Reply-To: <512A47C5.3010500@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2013 09:03 AM, Prarit Bhargava wrote:
>
> On 02/23/2013 06:11 PM, Alessandro Zummo wrote:
>> On 22/feb/2013, at 22:05, John Stultz <john.stultz@linaro.org> wrote:
>>
>>> On 02/22/2013 12:55 PM, Prarit Bhargava wrote:
>>>> On 02/22/2013 03:43 PM, John Stultz wrote:
>>>>> On 02/14/2013 09:02 AM, Prarit Bhargava wrote:
>>>>>> /sys/class/rtc/rtcX/date and /sys/class/rtc/rtcX/time currently have
>>>>>> read-only access.  This patch introduces write functionality which will
>>>>>> set the rtc time.
>>>>>>
>>>>>> Usage: echo YYYY-MM-DD > /sys/class/rtc/rtcX/date
>>>>>>          echo HH:MM:SS > /sys/class/rtc/rtcX/time
>>>>> Why do we want to add a new interface here?
>>>> John,
>>>>
>>>> I'm not adding a new interface.  The current date/time interface only handles
>>>> read and I'm introducing write.
>>>>
>>> Right, but what benefit does that provide?
>>> (I'm not saying there isn't any, its just not clear from your patch why this is a good thing.)
>>>
> Sorry John, I misunderstood your question.
>
>>> Also CC'ing Alessandro for his input.
>> I'd like to keep the interfaces as simple as possible but I'm open to improvements if there are good use cases.
>>
> AFAICT there is no way for me to "test" or use the write from userspace.
> hwclock uses the SET_TIME ioctl, which is a different code path AFAICT.

Yea, per your other email, I'd rather we drop this change for now.

If possible, instead of adding redundant userland interfaces, I'd rather 
we consolidate the redundant internal code paths.

thanks
-john

