Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaBYAFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:05:33 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63276 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752925AbaBYAFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:05:31 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Cc: linux-pm@vger.kernel.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Cpuidle: Deal with timer expiring in the past
Date: Tue, 25 Feb 2014 01:20:28 +0100
Message-ID: <4412976.XQe5SncyQX@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1402241201330.17677@knanqh.ubzr>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org> <1393223377-5744-7-git-send-email-tuukka.tikkanen@linaro.org> <alpine.LFD.2.11.1402241201330.17677@knanqh.ubzr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 24, 2014 12:05:39 PM Nicolas Pitre wrote:
> On Mon, 24 Feb 2014, Tuukka Tikkanen wrote:
> 
> > Sometimes (fairly often) when the cpuidle menu governor is making a decision
> > about idle state to enter the next timer for the cpu appears to expire in
> > the past. The menu governor expects the expiry to always be in the future
> > and in fact stores the time delta in an unsigned variable. However, when
> > the expiry is in the past, the value returned by tick_nohz_get_sleep_length
> > can be negative. This patch prevents using negative values, instead making
> > the governor return immediately similar to having latency requirement set
> > to 0.
> > 
> > Note: As with latency == 0, the return value is 0 with no check to see if
> > the state 0 has been disabled or not.
> 
> In your cover letter you mention some occurrences of the negative result 
> being observed on x86.  That information is worth capturing in the 
> commit log as well to distinguish between theoretical problems from 
> actual observations.

In my opinion that applies to the other patches in the series too.  In all
cases it would be good to know whether or not the problems addressed are
theoretical or they can be reproduced in practice (and if so, then how), or
they already have been reported by somebody.

In the two latter cases the patches would be good candidates for -stable,
in particular.

Thanks,
Rafael

