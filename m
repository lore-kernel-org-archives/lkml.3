Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3BANwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:52:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:34155 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3BANwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:52:09 -0500
Date: Fri, 1 Feb 2013 14:52:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tommi Rantala <tt.rantala@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: clock_nanosleep() task_struct leak
In-Reply-To: <CA+ydwtqUUAR9zf3dp+N1JRW+if88EZ73i+5BQtuggVPDFVdCBg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302011450160.11905@ionos>
References: <CA+ydwtqUUAR9zf3dp+N1JRW+if88EZ73i+5BQtuggVPDFVdCBg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2601;0cOn Fri, 1 Feb 2013, Tommi Rantala wrote:

> Hello,
> 
> Trinity discovered a task_struct leak with clock_nanosleep(), reproducible with:
> 
> -----8<-----8<-----8<-----
> #include <time.h>
> 
> static const struct timespec req;
> 
> int main(void) {
>         return clock_nanosleep(CLOCK_PROCESS_CPUTIME_ID,
>                         TIMER_ABSTIME, &req, NULL);
> }
> -----8<-----8<-----8<-----

Groan. That code probably has more than that leak burried inside.

Thanks,

	tglx
