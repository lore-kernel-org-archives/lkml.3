Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbaKSXxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:53:43 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:59601 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbaKSXxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:53:41 -0500
MIME-Version: 1.0
In-Reply-To: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org>
References: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org>
Date: Wed, 19 Nov 2014 15:53:40 -0800
Message-ID: <CALAqxLU+cGJyLaDVucCcL1V_WxzC6sKmy8XBHSMgXdeWjWStMA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/5] y2038 in-kernel interface changes for drivers/rtc
From: John Stultz <john.stultz@linaro.org>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 3:15 AM, pang.xunlei <pang.xunlei@linaro.org> wrote:
> On 32bit systems, the kernel uses a 32bit signed time_t value
> for seconds since 1970-01-01:00:00:00. This will overflow at
> 2038-01-19 03:14:08, and is widely known as the y2038 problem.
>
> To address this, the plan is to create 64bit internal interfaces
> which are 2038 safe, mark the unsafe versions as deprecated and
> then convert subsystems one by one over to the new interfaces.
> Once all users are converted, the deprecated internal functions
> will be removed.
>
> NOTE: In some cases, there are issues with 32bit values that are
> unsigned, and thus become y2106 issues. Since its somewhat simpler
> to unify the time types, we'll try to convert those usage to 64bit
> where it can be easily done. In those cases where a fix would be
> overly complicated, we'll simply explicitly mark the limitation.
>
> This patchset introduces the 64bit interfaces needed to convert
> the drivers/rtc subsystem, and to keep it relatively short some
> patches to demonstrate how the conversion will be done. If the
> feedback is positive on this series, we'll provide the full
> conversion series as well.
>
> pang.xunlei (5):
>   time: Provide y2038 safe do_settimeofday() replacement
>   time: Provide y2038 safe timekeeping_inject_sleeptime() replacement
>   time: Provide y2038 safe mktime() replacement
>   rtc/lib: Provide y2038 safe rtc_tm_to_time()/rtc_time_to_tm()
>     replacement
>   rtc/mc13xxx: Eliminate time problems

Ok, I've queued these up for testing in my tree. Hope to send them off
to Thomas for 3.19.

thanks
-john
