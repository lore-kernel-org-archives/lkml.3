Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab3DXSza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:55:30 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38799 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3DXSz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:55:29 -0400
Message-ID: <51782A9D.20303@linaro.org>
Date: Wed, 24 Apr 2013 11:55:25 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: lkml <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time
 optimizaitons
References: <1366828376-18124-1-git-send-email-john.stultz@linaro.org> <CAPXgP123q9K8-NibkpmbvwpRTM1cdODWycq3o-HdWEYBwoGCFQ@mail.gmail.com>
In-Reply-To: <CAPXgP123q9K8-NibkpmbvwpRTM1cdODWycq3o-HdWEYBwoGCFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 11:41 AM, Kay Sievers wrote:
> On Wed, Apr 24, 2013 at 8:32 PM, John Stultz <john.stultz@linaro.org> wrote:
>> Kay Sievers noted that the ALWAYS_USE_PERSISTENT_CLOCK config,
>> which enables some minor compile time optimization to avoid
>> uncessary code in mostly the suspend/resume path could cause
>> problems for userland.
>>
>> In particular, the dependency for RTC_HCTOSYS on
>> !ALWAYS_USE_PERSISTENT_CLOCK, which avoids setting the time
>> twice and simplifies suspend/resume, has the side effect
>> of causing the /sys/class/rtc/rtcN/hctosys flag to always be
>> zero, and this flag is commonly used by udev to setup the
>> /dev/rtc symlink to /dev/rtcN, which can cause pain for
>> older applications.
> FWIW, in the light of the original change, I've just removed the
> /dev/rtc creation from the default udev rules now, so that thing will
> be phased out in the future.
Is that actually wanted? What happens to applications that use /dev/rtc?

I think setting up the /dev/rtc link is important. Its just that setting 
it up exclusively by the hctosys flag is maybe more fragile then we'd 
like. Instead the hctosys flag maybe should only be used as a hint if 
there is more then one RTC available.

thanks
-john
