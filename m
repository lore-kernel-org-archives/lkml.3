Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab3FRSWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:22:52 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:33602 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab3FRSWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:22:51 -0400
Message-ID: <51C0A560.2020702@ahsoftware.de>
Date: Tue, 18 Jun 2013 20:22:24 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: rtc-linux@googlegroups.com
CC: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'John Stultz'" <john.stultz@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Subject: Re: [rtc-linux] Re: BUG: rtc: rtc_device_unregister() broken in 3.10-rcN
References: <51BB50B1.7060308@ahsoftware.de> <51BF2DD8.5030004@ahsoftware.de> <002901ce6bc7$71d32510$55796f30$@samsung.com>
In-Reply-To: <002901ce6bc7$71d32510$55796f30$@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.06.2013 03:59, schrieb Jingoo Han:
> On Tuesday, June 18, 2013 12:40 AM, Alexander Holler wrote:
>> Am 14.06.2013 19:19, schrieb Alexander Holler:
>>> Hello,
>>>
>>> I've just tested some things with 3.10-rc5+ and discovered that
>>> rtc_device_unregister is broken. This is most likely because of the
>>> switch to devm*. As 3.10 is already at -rc5, I'm posting this without
>
> CC'ed Dmitry Torokhov, Sachin Kamat
>
>
> Hi Alexander,
>
> You are using 'drivers/rtc/rtc-hid-sensor-time.c', right?
> If so, would you revert '479243b rtc: hid-sensor-time: use devm_rtc_device_register()',
> and give the result?
>
>
> Hi Dmitry, Sachin,
> You can see the kernel debug message, when the problem happens.
> (http://lists-archives.com/linux-kernel/27855385-bug-rtc-rtc_unregister_device-broken-in-3-10-rcn.html)
>

I've found the problem. Somehow I managed it with a patch i posted 
recently (3/9) to get the rtc_device_unregister() back into the 
remove-function of rtc-hid-sensor-time. Might be happend when rebasing 
the patch from 3.9.x to 3.10 or similiar, I don't know or remember.

I haven't seen it, because the backtrace doesn't show it. So what 
happend was likely:

remove -> rtc_device_unregister() (ok)
device remove -> devm -> rtc_device_unregister() (again) -> Crash.

Sorry for the noise.

Regards,

Alexander Holler
