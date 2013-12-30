Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3L3P0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 10:26:25 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:44458 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab3L3P0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 10:26:24 -0500
Date: Mon, 30 Dec 2013 16:26:17 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Question about /proc/uptime
Message-ID: <20131230162617.1b013251@mschwide>
In-Reply-To: <20131230151110.GA29636@redhat.com>
References: <1388025009.1176.17@driftwood>
	<20131227144504.GA17192@redhat.com>
	<20131230095656.4c78dd98@mschwide>
	<20131230151110.GA29636@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13123015-4966-0000-0000-000007F48F99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Dec 2013 16:11:10 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 12/30, Martin Schwidefsky wrote:
> <
> > On Fri, 27 Dec 2013 15:45:04 +0100
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > Add Frederic, I am not sure I understand this correctly.
> > >
> > > On 12/25, Rob Landley wrote:
> > > >
> > > > There are two values here, the first is seconds since boot time (which
> > > > is just elapsed time; at one point it was ajusted for suspend and that
> > > > was revered as confusing).
> > >
> > > Hmm, uptime_proc_show() still uses get_monotonic_boottime(), this should
> > > include suspend time?
> >
> > The first value of /proc/uptime is the amount of time the system has been
> > running, the sum of the suspend time is not included.
> 
> Hmm. It uses get_monotonic_boottime() and this helper adds
> timekeeper->total_sleep_time to the returned value? Even the comment says
> 
> 	* This is similar to CLOCK_MONTONIC/ktime_get_ts, but also
> 	* includes the time spent in suspend.
> 
> > timekeeping_resume()
> > is supposed to take care of that.
> 
> Not sure I understand... except that timekeeping_resume() does
> __timekeeping_inject_sleeptime().

Hmm, you are right. The sleeptime is added to the monotonic boottime. 
So the first value of /proc/uptime is the wall-time since boot.
And the second value is combined idle time over all cpus.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

