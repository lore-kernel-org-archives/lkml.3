Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaJXEWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 00:22:42 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:46206 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaJXEWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 00:22:40 -0400
MIME-Version: 1.0
In-Reply-To: <CADcy93UMxdD0AwgwAjLYNC7TtdttC5rb3D7N8FSskrbkCMh_HA@mail.gmail.com>
References: <1412838271-11175-1-git-send-email-pang.xunlei@linaro.org>
	<alpine.DEB.2.11.1410211210000.5308@nanos>
	<CALAqxLVtYeHX0qBkOFjf58opp9ympxbjFa2DsaYx-KOthqQS=w@mail.gmail.com>
	<alpine.DEB.2.11.1410212133450.5308@nanos>
	<CADcy93UMxdD0AwgwAjLYNC7TtdttC5rb3D7N8FSskrbkCMh_HA@mail.gmail.com>
Date: Thu, 23 Oct 2014 21:22:39 -0700
Message-ID: <CALAqxLW-Jc63WPcHYhT8SsWf-kex6=4JcNX7hUD6r7fd8B+0iQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] time: Fix NTP adjustment mult overflow.
From: John Stultz <john.stultz@linaro.org>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 5:37 AM, Xunlei Pang <pang.xunlei@linaro.org> wrote:
> The mult memember of struct clocksource should always be a large u32 number
> when calculated through
> __clocksource_updatefreq_scale(). The value of (cs->mult+cs->maxadj) may
> have a chance to reach very
> near 0xFFFFFFFF, so it may overflow when doing NTP positive adjustment, see
> the following detail:
> When NTP slewes the clock, kernel goes through
> update_wall_time()->...->timekeeping_apply_adjustment():
> tk->tkr.mult += mult_adj;
> Unfortunately, tk->tkr.mult may overflow after this operation.
>
>
> This patch avoids mult overflow by judging the overflow case before adding
> mult_adj to mult, also adds the
> WARNING message when capturing such case.
>
> Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>

I reworded this a bit further, but its in my queue for 3.19.

thanks
-john
