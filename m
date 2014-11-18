Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaKRONh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:13:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:39251 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaKRONf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:13:35 -0500
Date: Tue, 18 Nov 2014 15:13:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC PATCH v3 0/5] y2038 in-kernel interface changes for
 drivers/rtc
In-Reply-To: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1411181513040.3909@nanos>
References: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org>
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

That looks way better than the last attempt.

Thanks,

	tglx
