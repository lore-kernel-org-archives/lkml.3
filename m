Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3AVBTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 20:19:55 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51819 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3AVBTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 20:19:54 -0500
Date: Tue, 22 Jan 2013 01:18:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Sealey <matt@genesi-usa.com>
Cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130122011808.GF23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com> <50FDC2DD.7090406@linaro.org> <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com> <50FDE2AE.8030608@linaro.org> <CAKGA1bkXx2qn+c6sKqXsty-aFe1r-W79uyem0O8p6JNeeq6zxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1bkXx2qn+c6sKqXsty-aFe1r-W79uyem0O8p6JNeeq6zxQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 07:06:59PM -0600, Matt Sealey wrote:
> On Mon, Jan 21, 2013 at 6:51 PM, John Stultz <john.stultz@linaro.org> wrote:
> > On 01/21/2013 02:54 PM, Matt Sealey wrote:
> >>
> >> On Mon, Jan 21, 2013 at 4:36 PM, John Stultz <john.stultz@linaro.org>
> >> wrote:
> >>>
> >>> On 01/21/2013 01:14 PM, Matt Sealey wrote:
> >
> > As far as jiffies rating, from jiffies.c:
> >     .rating        = 1, /* lowest valid rating*/
> >
> > So I'm not sure what you mean by "the debug on the kernel log is telling me
> > it has a higher resolution".
> 
> Oh, it is just if I actually don't run setup_sched_clock on my
> platform, it gives a little message (with #define DEBUG 1 in
> sched_clock.c)

sched_clock() has nothing to do with time keeping, and that
HZ/NO_HZ/HRTIMERS don't affect it (when it isn't being derived from
jiffies).

Now, sched_clock() is there to give the scheduler a _fast_ to access,
higher resolution clock than is available from other sources, so that
there's ways of accurately measuring the amount of time processes run
for, and other such measurements - and it uses that to determine how
to schedule a particular task and when to preempt it.

Not providing it means you get those measurements at HZ-based resolution,
which is suboptimal for tasks which run often for sub-HZ periods (which
can end up accumulating zero run time.)
