Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbaACGBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 01:01:49 -0500
Received: from ni.piap.pl ([195.187.100.4]:46297 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaACGBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 01:01:48 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>
References: <m3mwjhux0e.fsf@t19.piap.pl> <20131231104511.GA9688@1wt.eu>
	<m3txdmu2ez.fsf@t19.piap.pl> <20140102101455.GG10158@pengutronix.de>
	<m3ppoatwn1.fsf@t19.piap.pl>
	<CA+55aFyZ0EXYkHd-BhQo6K++qKJVPdGeDbFTVTs3pAPCHFUpOA@mail.gmail.com>
Date: Fri, 03 Jan 2014 07:01:46 +0100
In-Reply-To: <CA+55aFyZ0EXYkHd-BhQo6K++qKJVPdGeDbFTVTs3pAPCHFUpOA@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 2 Jan 2014 11:38:56 -0800")
MIME-Version: 1.0
Message-ID: <m3k3ehtxh1.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: v3.13-rc6+ regression (ARM board)
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140103 #7232212, check: 20140103 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>   --- a/kernel/time/sched_clock.c
>   +++ b/kernel/time/sched_clock.c
>   @@ -36,6 +36,7 @@ core_param(irqtime, irqtime, int, 0400);
>
>    static struct clock_data cd = {
>           .mult   = NSEC_PER_SEC / HZ,
>   +       .seq = SEQCNT_ZERO(cd.seq),
>    };
>
>    static u64 __read_mostly sched_clock_mask;

Same here, problem still exists (tested with lockdep).
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
