Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab3DXDFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:05:41 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33171 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab3DXDFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:05:40 -0400
MIME-Version: 1.0
In-Reply-To: <517746E4.908@linaro.org>
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com>
 <517746E4.908@linaro.org>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 24 Apr 2013 05:05:18 +0200
Message-ID: <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK changes?
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 4:43 AM, John Stultz <john.stultz@linaro.org> wrote:
> On 04/23/2013 06:34 PM, Kay Sievers wrote:
>>
>> Hey,
>>
>> what's the intention of:
>>    e90c83f757fffdacec8b3c5eee5617dcc038338f ?
>>    x86: Select HAS_PERSISTENT_CLOCK on x86
>>
>> It unconditionally sets:
>>    HAS_PERSISTENT_CLOCK
>> but:
>>    RTC_SYSTOHC
>> got a depends on !HAS_PERSISTENT_CLOCK
>>
>> This makes it impossible to sync the system time from the RTC on x86.
>> What's going on here?
>
>
> So I suspect just some confusion, but let me know if thats wrong and you're
> actually seeing an issue.
>
> SYSTOHC is what *sets the RTC* to the system time when we're synced with
> NTP.
>
> HCTOSYS is what sets the system time from the RTC.

Right, and RTC_HCTOSYS is not NTP related. It just reads the time from
the RTC_HCTOSYS_DEVICE at bootup so we do not boot in 1970 time mode.
We need that it in all cases, at every bootup on x86. But it's no
longer there with the above commits. :)

Kay
