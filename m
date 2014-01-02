Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaABTjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 14:39:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57822 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaABTi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 14:38:57 -0500
MIME-Version: 1.0
In-Reply-To: <m3ppoatwn1.fsf@t19.piap.pl>
References: <m3mwjhux0e.fsf@t19.piap.pl>
	<20131231104511.GA9688@1wt.eu>
	<m3txdmu2ez.fsf@t19.piap.pl>
	<20140102101455.GG10158@pengutronix.de>
	<m3ppoatwn1.fsf@t19.piap.pl>
Date: Thu, 2 Jan 2014 11:38:56 -0800
X-Google-Sender-Auth: OJL4w7IgSV_nFGMdc_bjxCufVgY
Message-ID: <CA+55aFyZ0EXYkHd-BhQo6K++qKJVPdGeDbFTVTs3pAPCHFUpOA@mail.gmail.com>
Subject: Re: v3.13-rc6+ regression (ARM board)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 4:07 AM, Krzysztof Hałasa <khalasa@piap.pl> wrote:
>
> This means these two commits don't like each other:
>
>     seqcount: Add lockdep functionality to seqcount/seqlock structures
>     sched_clock: Use seqcount instead of rolling our own

Does something like this fix it for you?

  --- a/kernel/time/sched_clock.c
  +++ b/kernel/time/sched_clock.c
  @@ -36,6 +36,7 @@ core_param(irqtime, irqtime, int, 0400);

   static struct clock_data cd = {
          .mult   = NSEC_PER_SEC / HZ,
  +       .seq = SEQCNT_ZERO(cd.seq),
   };

   static u64 __read_mostly sched_clock_mask;

(The above is not even compile-tested, because x86 doesn't use
GENERIC_SCHED_CLOCK. So I did the patch blindly, but I think you get
the idea..)

            Linus
