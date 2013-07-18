Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965324Ab3GRUDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:03:55 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65461 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049Ab3GRUDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:03:40 -0400
Message-ID: <51E84A19.9010707@linaro.org>
Date: Thu, 18 Jul 2013 13:03:37 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Zoran Markovic <zoran.markovic@linaro.org>
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Arve Hjonnevag <arve@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: Re: [RFC PATCH] rtc: keep system awake until all expired RTC timers
 are handled
References: <1372288153-4731-1-git-send-email-zoran.markovic@linaro.org>
In-Reply-To: <1372288153-4731-1-git-send-email-zoran.markovic@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 04:09 PM, Zoran Markovic wrote:
> Current implementation of RTC interface allows for system suspend to
> occur in the following cases:
> (a) if a timer is set in the past and rtc_timer_do_work() is scheduled
> to handle it, and
> (b) if rtc_timer_do_work() is called to handle expired timers whose
> handlers implement a preemption point.
>
> A pending suspend request may be honoured in the above cases causing
> timer handling to be delayed until after the next resume. This is
> undesirable since timer handlers may have time-critical code to execute.
>
> This patch makes sure that the system stays awake until all expired
> timers are handled.
>
> Note that all calls to pm_stay_awake() are eventually paired with
> the single pm_relax() call in rtc_timer_do_work(), which is launched
> using schedule_work().
>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Arve Hjonnevag <arve@android.com>
> Cc: Todd Poynor <toddpoynor@google.com>
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>

Haven't seen any objections here, so I'll queue this for 3.12.

thanks
-john

