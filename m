Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaEMXao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 19:30:44 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64281 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaEMXam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 19:30:42 -0400
Date: Wed, 14 May 2014 01:30:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
Message-ID: <20140513233036.GH13828@localhost.localdomain>
References: <20140411151825.GX11096@twins.programming.kicks-ass.net>
 <CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
 <20140414110245.GG11096@twins.programming.kicks-ass.net>
 <CAKohpo==1=K0=gZz_Z_Y0zO2PtyvA-Q67_+VKTJN7kbQgbiHTg@mail.gmail.com>
 <20140414114744.GI11096@twins.programming.kicks-ass.net>
 <CAKohpon=_ZR+QbfacGT+G_atgcc21KMYG3YxPf0nkSDLBH8Q2A@mail.gmail.com>
 <20140414120600.GJ11096@twins.programming.kicks-ass.net>
 <20140415093002.GL1877@localhost.localdomain>
 <CAKohpomKLyK0XZbB2j1Gjxe123b6JkcdSTpvdFFD23Hb_EmmpA@mail.gmail.com>
 <CAKohpomik2L906GLST=XSG_zhDcCWMNBw4X7qJd8ejcOF0Fusw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomik2L906GLST=XSG_zhDcCWMNBw4X7qJd8ejcOF0Fusw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 02:14:10PM +0530, Viresh Kumar wrote:
> On 23 April 2014 16:42, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 15 April 2014 15:00, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> Ok, I'm a bit buzy with a conference right now but I'm going to summarize that
> >> soonish.
> 
> Hi Frederic,
> 
> Please see if you can find some time to close this, that would be very
> helpful :)
> 
> Thanks

I'm generally worried about the accounting in update_curr() that periodically
updates stats. I have no idea which of these stats could be read by other CPUs:
vruntime, load bandwitdth, etc...

Also without tick:

* we don't poll anymore on trigger_load_balance()

* __update_cpu_load() requires fixed rate periodic polling. Alex Shi had
patches for that but I'm not sure if that's going to be merged

* rq->rt_avg accounting?
