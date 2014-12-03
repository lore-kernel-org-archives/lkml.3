Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaLCUD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:03:56 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:57696 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLCUDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:03:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] optimize ktime_divns for constant divisors
Date: Wed, 03 Dec 2014 21:03:48 +0100
Message-ID: <3913269.qTFsa05Ysv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1412031424150.470@knanqh.ubzr>
References: <alpine.LFD.2.11.1412031424150.470@knanqh.ubzr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:r88vzSr25LewZgNmCI5IdPIQeNMY7D74eZnLp1OLlk/k6t6xrbX
 QWIf3F0I8OBoSTM+rbYgClCNCKWDEgwHlvdBBSwVWhgGb0bLD+X9wAAoIKW4mpRVg1EEqZK
 9D2YQRivIWwiFveL6BttMo9uFjsPn6vRe8t7cP3A16tzjl73mouKfZPuQz2zj+aOod95uKk
 ajqfwoESihz/im6SGxe1A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 14:43:06 Nicolas Pitre wrote:
> At least on ARM, do_div() is optimized to turn constant divisors into
> an inline multiplication by the reciprocal value at compile time. 
> However this optimization is missed entirely whenever ktime_divns() is
> used and the slow out-of-line division code is used all the time.
> 
> Let ktime_divns() use do_div() inline whenever the divisor is constant
> and small enough.  This will make things like ktime_to_us() and 
> ktime_to_ms() much faster.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>

Very cool. I've been thinking about doing something similar for the
general case but couldn't get the math to work.

Can you think of an architecture-independent way to ktime_to_sec,
ktime_to_ms, and ktime_to_us efficiently based on what you did for
the ARM do_div implementation?

	Arnd
