Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaGHJuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:50:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:54598 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaGHJuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:50:22 -0400
Date: Tue, 8 Jul 2014 11:50:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hyogi Gim <hyogi.gim@lge.com>
cc: John Stultz <john.stultz@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alarmtimers: verify the alarmtimer_type value from
 clock2alarm()
In-Reply-To: <1404809367-30207-1-git-send-email-hyogi.gim@lge.com>
Message-ID: <alpine.DEB.2.10.1407081148230.4357@nanos>
References: <1404809367-30207-1-git-send-email-hyogi.gim@lge.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, Hyogi Gim wrote:

> clock2alarm() can return a minus value. so, we cannot use this
> returned value for a index of an array. but, some functions use
> this value directly as a index of an array:
>  - alarm_clock_getres()
>  - alarm_clock_get()
>  - alarm_timer_create()
>  - alarm_timer_nsleep()
> 
> add the verification code for the returned alarmtimer_type from
> clock2alarm().

That's really pointless.

These functions are called from the core posix timer code if user
space requests CLOCK_REALTIME_ALARM or CLOCK_BOOTTIME_ALARM. So the
argument is already validated.

Thanks,

	tglx

 
