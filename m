Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaC1KnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:43:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61585 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaC1KnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:43:19 -0400
MIME-Version: 1.0
Date: Fri, 28 Mar 2014 16:13:18 +0530
Message-ID: <CAKohpo=L8ZiR67OR0Sz0LeGdRxn92rfbJbsHd-ybt==MwfQJ3Q@mail.gmail.com>
Subject: [Query]: hrtimer: Does switch_hrtimer_base() need to check hrtimer_check_target()?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I couldn't understand one part of hrtimer (obviously there are
others as well, but here I am sure I couldn't understood it :)).

In switch_hrtimer_base() we are calling hrtimer_check_target()
which guarantees this:

/*
 * With HIGHRES=y we do not migrate the timer when it is expiring
 * before the next event on the target cpu because we cannot reprogram
 * the target cpu hardware and we would cause it to fire late.
 *
 * Called with cpu_base->lock of target cpu held.
 */

But switch_hrtimer_base() is only called from one place, i.e.
__hrtimer_start_range_ns() and at the point (where we call
switch_hrtimer_base()) expiration time is not yet known as
we call this routine later:

hrtimer_set_expires_range_ns()

So, do we really need to call hrtimer_check_target() at all
in switch_hrtimer_base()? Or do we need to move
hrtimer_set_expires_range_ns() before calling
switch_hrtimer_base() ??

--
viresh
