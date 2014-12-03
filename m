Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaLCTsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:48:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaLCTsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:48:38 -0500
Date: Wed, 3 Dec 2014 14:30:29 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141203193029.GA1122@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <john.stultz@linaro.org>
References: <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
 <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net>
 <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com>
 <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141203190045.GB32005@redhat.com>
 <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:25:29AM -0800, Linus Torvalds wrote:
 > On Wed, Dec 3, 2014 at 11:00 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > So right after sending my last mail, I rebooted, and restarted the run
 > > on the same kernel again.
 > >
 > > As I was writing this mail, this happened.
 > >
 > > [  524.420897] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c178:20182]
 > >
 > > and that's all that made it over the console. I couldn't log in via ssh,
 > > and thought "ah-ha, so it IS bad".  I walked over to reboot it, and
 > > found I could actually log in on the console. check out this dmesg..
 > >
 > > [  503.683055] Clocksource tsc unstable (delta = -95946009388 ns)
 > > [  503.692038] Switched to clocksource hpet
 > > [  524.420897] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c178:20182]
 > 
 > Interesting. That whole NMI watchdog thing happens pretty much 22s
 > after the "TSC unstable" message.
 > 
 > Have you ever seen that TSC issue before? The watchdog relies on
 > comparing get_timestamp() differences, so if the timestamp was
 > incorrect...
 
yeah, quite a lot.

# grep tsc\ unstable /var/log/messages* | wc -l
71

Usually happens pretty soon after boot, once I start the fuzzing run.
It sometimes occurs quite some time before the NMI issue though.

eg:

Dec  3 11:50:24 binary kernel: [ 4253.432642] Clocksource tsc unstable (delta = -243666538341 ns)
...
Dec  3 13:24:28 binary kernel: [ 9862.915562] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c29:13237]


	Dave
