Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3DYNMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:12:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab3DYNM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:12:29 -0400
Message-ID: <1366895538.6139.19.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tim Sander <tim.sander@hbm.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 25 Apr 2013 15:12:18 +0200
In-Reply-To: <517927C2.40402@linutronix.de>
References: <1366760662.9609.176.camel@gandalf.local.home>
	 <2156546.QlsX0XyPQz@dabox> <51792277.8000205@linutronix.de>
	 <1366893374.6139.5.camel@marge.simpson.net> <517927C2.40402@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:ELSAMuXRD9W/n2n76leNk2XCQBK0ijIx0EUP/WQ469k
 xqgBVXcB6NsjMBG+99F2DupoR49dCdPfCcgfFHQfKfysFA/lxd
 BqWBoB1nDXVkUxn2nIn3XlOlpuoHlBgW/1fFxzbpZgyWjZssaD
 sq1ktQbC2XgB0yj2o4itSS2dQQnJTIoah1au7KokWHTO8B8/Iw
 aHMyIHstveFhuD8Xl3RV42IQmrnXCypFrrK9gvFRco+C9Irw5A
 Hdi1mQz4I8pfPNNa7EPmkaFL7KzpThBGwkrxtQBs51mDCYDpWO
 dUSzI+DdOFG9p7ZTGTw4jwbEWprSB4NNiyd1+o5vzx7h9selsA
 XW0rDYbl3hlCNQUasS7c95IcexsxgFW/EH5RKJ8OFRsCS3dBqQ
 kS450ZL3vlarw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 14:55 +0200, Sebastian Andrzej Siewior wrote: 
> On 04/25/2013 02:36 PM, Mike Galbraith wrote:
> > hrtimer: fix hrtimer free zone build bug
> > 
> > Signed-off-by: Mike Galbraith <bitbucket@online.de>
> > 
> > diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> > index 2328c04..31d57a2 100644
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -1036,7 +1036,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
> >  		&& hrtimer_enqueue_reprogram(timer, new_base)) {
> >  
> >  		if (wakeup
> > -#ifdef CONFIG_PREEMPT_RT_BASE
> > +#if defined(CONFIG_PREEMPT_RT_BASE) && defined(CONFIG_HIGH_RES_TIMERS)
> >  		    /*
> >  		     * Move softirq based timers away from the rbtree in
> >  		     * case it expired already. Otherwise we would have a
> > 
> > 
> 
> hrtimer_enqueue_reprogram() returns 0 in non-high res case so
> everything down there is never reached. The compiler should see this :)

-Werror=

  CC      kernel/hrtimer.o
kernel/hrtimer.c: In function ‘__hrtimer_start_range_ns’:
kernel/hrtimer.c:1045:7: error: implicit declaration of function ‘hrtimer_rt_defer’ [-Werror=implicit-function-declaration]
kernel/hrtimer.c: At top level:
kernel/hrtimer.c:1416:12: error: static declaration of ‘hrtimer_rt_defer’ follows non-static declaration
kernel/hrtimer.c:1045:10: note: previous implicit declaration of ‘hrtimer_rt_defer’ was here
cc1: some warnings being treated as errors

make[1]: *** [kernel/hrtimer.o] Error 1
make: *** [kernel/hrtimer.o] Error 2
git@marge:~/linux-2.6>

