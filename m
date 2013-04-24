Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3DXDTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:19:36 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43849 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab3DXDTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:19:35 -0400
Message-ID: <51774F44.2060704@linaro.org>
Date: Tue, 23 Apr 2013 20:19:32 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com> <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com>
In-Reply-To: <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:05 PM, Kay Sievers wrote:
> On Wed, Apr 24, 2013 at 4:43 AM, John Stultz <john.stultz@linaro.org> wrote:
>> On 04/23/2013 06:34 PM, Kay Sievers wrote:
>>> Hey,
>>>
>>> what's the intention of:
>>>     e90c83f757fffdacec8b3c5eee5617dcc038338f ?
>>>     x86: Select HAS_PERSISTENT_CLOCK on x86
>>>
>>> It unconditionally sets:
>>>     HAS_PERSISTENT_CLOCK
>>> but:
>>>     RTC_SYSTOHC
>>> got a depends on !HAS_PERSISTENT_CLOCK
>>>
>>> This makes it impossible to sync the system time from the RTC on x86.
>>> What's going on here?
>>
>> So I suspect just some confusion, but let me know if thats wrong and you're
>> actually seeing an issue.
>>
>> SYSTOHC is what *sets the RTC* to the system time when we're synced with
>> NTP.
>>
>> HCTOSYS is what sets the system time from the RTC.
> Right, and RTC_HCTOSYS is not NTP related. It just reads the time from
> the RTC_HCTOSYS_DEVICE at bootup so we do not boot in 1970 time mode.
> We need that it in all cases, at every bootup on x86. But it's no
> longer there with the above commits. :)
On x86 the persistent_clock() is backed by the 
CMOS/EFI/kvm-wall/xen/vrtc clock (all via x86_platform.get_wallclock) 
should be present and we'll initialize the time in timekeeping_init() there.

Its only systems where there isn't a persistent_clock is where the RTC 
layer and the HCTOSYS is helpful.

Again, if you're having a problem where an x86 system isn't getting its 
time initialized correctly, please let me know the details of the system.

thanks
-john



