Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbbANIU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:20:59 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:42442 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbANIU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:20:57 -0500
MIME-Version: 1.0
In-Reply-To: <20150108012616.GQ9759@ld-irv-0074>
References: <1418873011-4974-1-git-send-email-zhang.chunyan@linaro.org>
	<4170676.z5yoWA4Rtc@wuerfel>
	<20150108012616.GQ9759@ld-irv-0074>
Date: Wed, 14 Jan 2015 16:20:56 +0800
Message-ID: <CAG2=9p-CJyFiid2=eA5cOi7zt9oSxScfsox5YVNngfN9nQz8-Q@mail.gmail.com>
Subject: Re: [PATCH v3] mtd: test: Replace timeval with ktime_t in speedtest.c
 and torturetest.c
From: Chunyan Zhang <zhang.chunyan@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Arnd Bergmann <arnd@linaro.org>, David Woodhouse <dwmw2@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Lyra Zhang <zhang.lyra@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Brian

Thank you so much !

Best regards,
Chunyan

On Thu, Jan 8, 2015 at 9:26 AM, Brian Norris
<computersforpeace@gmail.com> wrote:
> On Thu, Dec 18, 2014 at 08:53:10AM +0100, Arnd Bergmann wrote:
>> On Thursday 18 December 2014 11:23:31 Chunyan Zhang wrote:
>> > This patch changes the 32-bit time type (timeval) to the 64-bit one
>> > (ktime_t), since 32-bit time types will break in the year 2038.
>> >
>> > I use ktime_t instead of timeval to define 'start' and 'finish'
>> > which are used to get the time for tow points.
>> >
>> > This patch also changes do_gettimeofday() to ktime_get() accordingly,
>> > since ktime_get returns a ktime_t, but do_gettimeofday returns a
>> > struct timeval, and the other reason is that ktime_get() uses
>> > the monotonic clock.
>> >
>> > This patch is based on another patch which privides a millisecond
>> > time difference function 'ktime_ms_delta' in ktime.h
>> >
>> > http://lkml.iu.edu//hypermail/linux/kernel/1412.2/00625.html
>> >
>> > Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
>> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>> >
>>
>> The new version still looks good to me, but as there is now a
>> dependency on another patch, I'd suggest we queue this up in the
>> y2038 branch together with the patch that introduces ktime_ms_delta.
>>
>> David or Brian, can you provide an Ack for this, or do you have
>> any objections?
>
> I just tested v2, which doesn't have this dependency and has only a
> trivial difference from v3. Seems to work OK. So:
>
> Tested-by: Brian Norris <computersforpeace@gmail.com>
> Acked-by: Brian Norris <computersforpeace@gmail.com>
>
> Feel free to queue it in the dependent branch.
>
> Thanks,
> Brian
