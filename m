Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaACRpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:45:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56243 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaACRpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:45:11 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-ce-52c6f724577f
Message-id: <52C6F722.3090704@samsung.com>
Date: Fri, 03 Jan 2014 21:45:06 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, anton@enomsg.org, kyungmin.park@samsung.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/3] Deferrable timers support for timerfd API
References: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
 <52C5F38D.5060201@linaro.org>
In-reply-to: <52C5F38D.5060201@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xy7oq348FGWz5amwxZ/0aNouDWzUt
	zvzWtTjb9Ibd4vKuOWwOrB4T+j8xety5tofN48SM3ywefVtWMXp83iQXwBrFZZOSmpNZllqk
	b5fAlfH01Er2gv+cFa8PrmVsYGzh6GLk4JAQMJHY9yOxi5ETyBSTuHBvPVsXIxeHkMBSRolV
	81exQDifGSU6u6awg1TxCmhJ7Jp3GcxmEVCVeLz9EDPIIDYBA4l992xBTFGBCImjyzUhqgUl
	fky+xwJiiwhoSCxccpUJpIRZIEti5v1ikLCwgJPErvkvmUBsIYF0iWtTd4DZnECLnh9rB2tl
	FrCWWDlpGyOELS+xec1b5gmMArOQbJiFpGwWkrIFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS
	83M3MULC+OsOxqXHrA4xCnAwKvHwZpw8FiTEmlhWXJl7iFGCg1lJhDfwDVCINyWxsiq1KD++
	qDQntfgQIxMHp1QDI8/sylf1kwufhnzrO5zGZFvL/8luzuvf/E9POnwKatS4/njqRMmHJ2ct
	OSykVbJtnfypsmUiaU+YmN1erNMwYznrInJvx+EJq0QDO9XmsvMrzeXaKW9qaNrwsuZU43Ev
	6TCrvIV7d55bcfnGiePZ04NPM7ju3O75+lFjBl+8P8sEx9pzPWL285RYijMSDbWYi4oTAecY
	AChBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 03:17 AM, John Stultz wrote:
> On 01/02/2014 10:30 AM, Alexey Perevalov wrote:
>> This version introduces new clockid (CLOCK_DEFERRABLE) , for timerfd_create, instead of
>> new flag (TFD_TIMER_DEFERRABLE) for timerfd_settime introduced in previous version.
> So why did you make this change?
>
> thanks
> -john
>
>

I looked at alarm timers and found approach of making timer behavior 
persistent per file descriptor is better than
changeable by timerfd_settime. I think "end user wake up from suspend" 
and "don't wake up in idle" is the same thing on the same abstraction level.

Yes Anton's previous  patches worked with CLOCK_MONOTONIC only and I 
didn't intend to use it with CLOCK_REALTIME, cause it's hard to me to 
find such use case.
Another way - it's stay as was Anton's patch, I mean as flag for the 
timerfd_settime, but in original patch set both hrtimer and deferrable 
timers initialized in timerfd_create, I think it's not needed. Also 
ability to change timer behavior looks not good if you couldn't change 
alarm timer behavior, not unified API.

If I'm right, only high resolution timer could be REALTIME, and there is 
no deferrable behavior for hrtimer only for timer_list.


-- 
Best regards,
Alexey Perevalov
