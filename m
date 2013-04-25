Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3DYMtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:49:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54792 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab3DYMtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:49:11 -0400
Message-ID: <1366894136.6139.9.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
From: Mike Galbraith <bitbucket@online.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tim Sander <tim.sander@hbm.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 25 Apr 2013 14:48:56 +0200
In-Reply-To: <1366893787.10248.4.camel@gandalf.local.home>
References: <1366760662.9609.176.camel@gandalf.local.home>
	 <2156546.QlsX0XyPQz@dabox> <51792277.8000205@linutronix.de>
	 <1366893374.6139.5.camel@marge.simpson.net>
	 <1366893787.10248.4.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:nrIFdPWAv6F+2OQRL6ciormcycUowAz3SJIEk0sOPgC
 ThuR8pKR0KKgAF469sIOg9g1PuMDJSyirTmaBxyFMmH1rBrFgY
 mkGzXYDuPmXRUg4fCSzDeTGCbSsmdhVwa3TJFcdP8OTkhFBZ9f
 ODxnNlt9lLjg+XSaFVsc088pF6ZzWzFVRS5n2gQ4J6eMs7XZIR
 iiUGBFBUs9GT8MMIUR2itTZhoXzOR+kiCYguK4a/02UrJGrpxp
 TTH5odp9Fcif/t7MqlbRpQkn3LHVvln6yBY2TGTLhOEZtjGSue
 3ilGX+Y7agcgQyar2PpqQYQTrbQs2vsnSTMbb/zatx4k3IW7Xi
 AW7bdgOlZsJODbgcfTPw92C0zfjiexqg8sebTblnOFccIkjVRN
 l9YiHdvr6oTIw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 08:43 -0400, Steven Rostedt wrote: 
> On Thu, 2013-04-25 at 14:36 +0200, Mike Galbraith wrote:
> > On Thu, 2013-04-25 at 14:32 +0200, Sebastian Andrzej Siewior wrote: 
> > > On 04/25/2013 01:14 PM, Tim Sander wrote:
> > > > Hi 
> > > > 
> > > > I just wanted to test this release but it fails to compile with the the 
> > > > following error:
> > > > 
> > > > kernel/hrtimer.c: In function '__hrtimer_start_range_ns':
> > > > kernel/hrtimer.c:1045:7: error: implicit declaration of function 
> > > > 'hrtimer_rt_defer'
> > > > kernel/hrtimer.c: At top level:
> > > > kernel/hrtimer.c:1416:12: error: static declaration of 'hrtimer_rt_defer' 
> > > > follows non-static declaration
> > > > kernel/hrtimer.c:1045:10: note: previous implicit declaration of 
> > > > 'hrtimer_rt_defer' was here
> > > > 
> > > > The kernelconfig is attached.
> > > 
> > > You do not have CONFIG_HIGH_RES_TIMERS defined. Is this on purpose?
> > 
> > git@marge:~/linux-2.6> ls -1 arch/arm/configs|wc -l
> > 122
> > git@marge:~/linux-2.6> grep -IR CONFIG_HIGH_RES_TIMERS arch/arm/configs|wc -l
> > 31
> > 
> > Oh.  Sniff, poor little things.
> > 
> > hrtimer: fix hrtimer free zone build bug
> 
> Perhaps the better solution is to select HIGH_RES_TIMERS when
> PREEMPT_RT_FULL is selected?

If they have support, most definitely.  I got the impression lots of ARM
boxen are impoverished.. why else would they not have it already set?

-Mike


