Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab3DXV0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:26:22 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55232 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049Ab3DXV0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:26:21 -0400
Message-ID: <51784DF9.7010302@linaro.org>
Date: Wed, 24 Apr 2013 14:26:17 -0700
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
References: <1366828376-18124-1-git-send-email-john.stultz@linaro.org> <CAPXgP12_auNLogaK0J8yj7_Nhf=B+Anh9NVNGTM3TqT15OKRFQ@mail.gmail.com>
In-Reply-To: <CAPXgP12_auNLogaK0J8yj7_Nhf=B+Anh9NVNGTM3TqT15OKRFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 12:44 PM, Kay Sievers wrote:
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
> An alternative to reverting this could be to set that flag
> unconditionally on the rtc that matches the persistent clock the
> kernel uses internally?
>
> I mean regardless of the pretty weird config option
> CONFIG_RTC_HCTOSYS_DEVICE, which internally just does a strcmp() with
> the given device name when the flag is queried. :)
>
> Can't we just have the same interface and your original optimization
> on x86, even without CONFIG_RTC_HCTOSYS_DEVICE enabled at all?

This might be possible, but I'd rather it be part of the unification 
work w/ the persistent_clock and the RTC code, rather then a quick hack.

thanks
-john

