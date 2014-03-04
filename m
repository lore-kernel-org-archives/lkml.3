Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaCDGkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 01:40:22 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:35478 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaCDGkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 01:40:21 -0500
MIME-Version: 1.0
In-Reply-To: <1393911500.6415.18.camel@marge.simpson.net>
References: <1393911500.6415.18.camel@marge.simpson.net>
Date: Tue, 4 Mar 2014 14:40:20 +0800
Message-ID: <CALAqxLUeb2GuPyULnHL+FHgbdanVxz2JsvD2O0bJWKyN=CJ3UQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()
From: John Stultz <john.stultz@linaro.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "Cc: Salman Qazi" <sqazi@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 1:38 PM, Mike Galbraith <bitbucket@online.de> wrote:
> (crap crap crap... M.A.I.N.T.A.I.N.E.R.S _dummy_)
>
> clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()
>
> As per 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock",
> cycles * mult >> shift is overflow prone. so give it the same treatment.
>
> Cc: Salman Qazi <sqazi@google.com>
> Cc: John Stultz <john.stultz@linaro.org>,
> Signed-off-by: Mike Galbraith <bitbucket@online.de>

Thanks for sending this in!  Curious exactly how the issue was being
triggered?  To some extent the cyclecounter/timecounter code never got
the adoption I expected, so I've sort of had it on my list to see
about killing that code off and merging its users w/ clocksources
(since the clocksource has been simplified since cyclecounters
landed). So curious to see what its actually being used for..
particularly since the timecounter code does have accumulation logic
which should avoid overflows (and deal with hardware counters that
wrap).

I'll put this in my 3.15 queue.

thanks
-john
