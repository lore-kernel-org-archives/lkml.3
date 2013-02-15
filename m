Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3BOWeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:34:37 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58187 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab3BOWeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:34:36 -0500
MIME-Version: 1.0
In-Reply-To: <511912BB.2060602@sysgo.com>
References: <511912BB.2060602@sysgo.com>
Date: Fri, 15 Feb 2013 14:34:33 -0800
X-Google-Sender-Auth: hS9aTQ4o_bAMf2zzpsrcFmDvrXI
Message-ID: <CANcMJZAuKo9yQkErDZYtBx-Bm92hMAG3SDK-DJRPn=m=T9hcag@mail.gmail.com>
Subject: Re: timekeeping_adjust may set mult to 0
From: John Stultz <john.stultz@linaro.org>
To: David Engraf <david.engraf@sysgo.com>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 7:48 AM, David Engraf <david.engraf@sysgo.com> wrote:
> I have encountered a problem when a linux system uses a clocksource with
> mult = 1 and shift = 0 (clocksource cycle = nanoseconds). It may happen that
> the function timekeeping_adjust reduces the value of mult to 0 when error is
> lower than the interval [1].
> As soon as timekeeper.mult is 0, ktime_get will no longer work because it
> uses timekeeping_get_ns which converts the cycle to nanoseconds with mult as
> 0 and the system clocksource returns always 0.

So you *don't* want to use shift=0, since that kills the ability for
the frequency adjustment code to do anything, as you've found.

Instead of calculating the clocksource mult/shift pair yourself,
please use clocksource_register_hz/khz().

I'm hoping to kill off the open clocksource_register() call soon, to
avoid this sort of confusion. Sorry for the trouble.

thanks
-john
