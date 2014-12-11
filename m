Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbaLKFSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 00:18:52 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:49015 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbaLKFSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 00:18:51 -0500
MIME-Version: 1.0
In-Reply-To: <54892111.3000102@linux.vnet.ibm.com>
References: <CA+iXiiOhPxvJKR5-9U_9Hd6mOnXJadBS+WRZhtv3yPw2r8KgJQ@mail.gmail.com>
	<54883DB6.10504@linux.vnet.ibm.com>
	<CAKohpokJxXe2RNc4Jqb20PJo2adr49nKBbzdXzYk9=H4kNjfRQ@mail.gmail.com>
	<54892111.3000102@linux.vnet.ibm.com>
Date: Thu, 11 Dec 2014 10:48:50 +0530
Message-ID: <CAKohpo=VOKF3wgvpp4Ut4jY4PgkD49+tGsU0EMFbU_LXw_d+aw@mail.gmail.com>
Subject: Re: [Query] Spurious interrupts from clockevent device on X86 Ivybridge
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Santosh Shukla <santosh.shukla@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 December 2014 at 10:14, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> I was talking of the case where we get an interrupt from the clockevent
> device but dont find the hrtimer to service and not really of an anomaly
> in timekeeping.

For sure that's a problem then and its obviously spurious unless we wanted
it to behave that way.

>    For instance one of the issues that we had seen earlier wherein we
> cancel the tick-sched-timer before going tickless, but since we had
> programmed the clock event device to fire, we get a spurious interrupt.

Yeah and so we need something like ONESHOT_STOPPED there..

I thought you are also talking about some *possible* races which might
occur between cancelling a timer and hrtimer_interrupt() getting called.
Don't know if such a race is possible though.
