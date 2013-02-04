Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3BDTd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:33:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab3BDTdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:33:24 -0500
Date: Mon, 4 Feb 2013 20:32:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tommi Rantala <tt.rantala@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: clock_nanosleep() task_struct leak
Message-ID: <20130204193223.GA11910@redhat.com>
References: <CA+ydwtqUUAR9zf3dp+N1JRW+if88EZ73i+5BQtuggVPDFVdCBg@mail.gmail.com> <alpine.LFD.2.02.1302011450160.11905@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1302011450160.11905@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Thomas Gleixner wrote:
>
> B1;2601;0cOn Fri, 1 Feb 2013, Tommi Rantala wrote:
>
> > Hello,
> >
> > Trinity discovered a task_struct leak with clock_nanosleep(), reproducible with:
> >
> > -----8<-----8<-----8<-----
> > #include <time.h>
> >
> > static const struct timespec req;
> >
> > int main(void) {
> >         return clock_nanosleep(CLOCK_PROCESS_CPUTIME_ID,
> >                         TIMER_ABSTIME, &req, NULL);
> > }
> > -----8<-----8<-----8<-----

posix_cpu_timer_create()->get_task_struct() I guess...

Cough. I am not sure I ever understood this code, but now it certainly
looks as if I never saw it before.

All I can say is: I'll try to take another look tomorrow :/

> Groan. That code probably has more than that leak burried inside.

Oh. yes... but if you meant something connected to this particular
"test-case" please tell us ;)

Oleg.

