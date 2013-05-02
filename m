Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab3EBS61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:58:27 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37111 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab3EBS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:58:25 -0400
Message-ID: <5182B74E.8060909@linaro.org>
Date: Thu, 02 May 2013 11:58:22 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: Pavel Machek <pavel@ucw.cz>, Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        Benoit Goby <benoit@android.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>
Subject: Re: [RFC PATCH] power: Add option to log time spent in suspend
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org> <1367360914-23389-2-git-send-email-zoran.markovic@linaro.org> <20130501002929.GA20042@amd.pavel.ucw.cz> <CAMbhsRRisa15fH9AodepfRJUv6t6dipqb6CMbOOrtzVsMUCoxQ@mail.gmail.com> <20130502122747.GA22618@amd.pavel.ucw.cz> <CAMbhsRQ4tCQtSxA-5tqydKp-xQf1bnrsq7GNw5q0gk3NdPZyaA@mail.gmail.com>
In-Reply-To: <CAMbhsRQ4tCQtSxA-5tqydKp-xQf1bnrsq7GNw5q0gk3NdPZyaA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 11:29 AM, Colin Cross wrote:
> On Thu, May 2, 2013 at 5:27 AM, Pavel Machek <pavel@ucw.cz> wrote:
>>
>>> dmesg is not the solution, it's not a stable api, it would require
>>> constant parsing to make sure you didn't miss data before it fell out
>>> of the ringbuffer, and sched_clock often does not (and should not)
>>> tick during suspend, so printk times don't show the time spent
>>> suspended.
>> If timing info printed is invalid, that should be fixed.
> It's not invalid, its just not measuring the time that is useful here.
>   printk is measuring something similar to (but not exactly the same
> as) CLOCK_MONOTONIC, but this is measuring something similar to
> CLOCK_BOOTTIME.

One thing I'm curious about with this patch, since we measure and keep 
track of suspend time in the timekeeping core, there may be enough 
justification to adding this sort of debugging info the timekeeping core 
itself.

Although what is being tracked with this driver isn't just total time in 
suspend, but looks like more of a logarithmic histogram of suspend 
times. Is there any context you can provide as to why that particular 
format was chosen (which would could be added to help improve the commit 
message)?

thanks
-john

