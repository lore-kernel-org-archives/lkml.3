Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab3EQSjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:39:13 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:59728 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab3EQSjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:39:11 -0400
Message-ID: <5196794C.2030005@linaro.org>
Date: Fri, 17 May 2013 11:39:08 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zoran Markovic <zoran.markovic@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Feng Tang <feng.tang@intel.com>, stable@vger.kernel.org
Subject: Re: [RFC PATCH] timekeeping: Correct run-time detection of real-time
 clock.
References: <1368815045-21209-1-git-send-email-zoran.markovic@linaro.org>
In-Reply-To: <1368815045-21209-1-git-send-email-zoran.markovic@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 11:24 AM, Zoran Markovic wrote:
> Since commit <31ade30692dc9680bfc95700d794818fa3f754ac>, timekeeping_init()
> checks for presence of persistent clock by attempting to read a non-zero
> time value from real-time clock. This is an issue on platforms where
> persistent_clock (instead of a RTC) is implemented as a free-running counter
> starting from zero on each boot and running during suspend. Examples are some
> ARM platforms (e.g. PandaBoard). An attempt to read such a clock during
> timekeeping_init() may return zero value and falsely declare persistent clock
> as missing. Additionally, in the above case suspend times may be accounted
> twice (once from timekeeping_resume() and once from rtc_resume()), resulting
> in a gradual drift of system time.
>
> This patch does a run-time correction of the issue by doing the same check
> during timekeeping_suspend().
>
> A better long-term solution would have to return error when trying to read
> non-existing clock and zero when trying to read an uninitialized clock, but
> that would require changing all persistent_clock implementations.
>
> This patch addresses the immediate breakage, for now.
>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>

Thanks for finding and sending this out!  I'll queue this for 3.10.

thanks again
-john




