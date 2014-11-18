Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaKRMF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:05:26 -0500
Received: from www.linutronix.de ([62.245.132.108]:38553 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaKRMFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:05:25 -0500
Date: Tue, 18 Nov 2014 13:05:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC PATCH v3 2/5] time: Provide y2038 safe timekeeping_inject_sleeptime()
 replacement
In-Reply-To: <1416309320-7498-3-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1411181303520.3909@nanos>
References: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org> <1416309320-7498-3-git-send-email-pang.xunlei@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, pang.xunlei wrote:

> As part of addressing "y2038 problem" for in-kernel uses, this
> patch adds timekeeping_inject_sleeptime64() using timespec64.
> 
> After this patch, timekeeping_inject_sleeptime() is deprecated
> and all its call sites will be fixed using the new interface,
> after that it can be removed.
> 
> NOTE: timekeeping_inject_sleeptime() is safe actually, but we
> want to eliminate timespec eventually, so comes this patch.

While it's safe, the change gets rid of the timespec conversion, so
it makes sense on its own.
 
> -	tmp = timespec_to_timespec64(*delta);
> -	__timekeeping_inject_sleeptime(tk, &tmp);
> +	__timekeeping_inject_sleeptime(tk, delta);

Thanks,

	tglx
