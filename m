Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaE1Gqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:46:55 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:62584 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaE1Gqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:46:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, minyard@acm.org
Cc: Corey Minyard <cminyard@mvista.com>, Stanislav Meduna <stano@meduna.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: Set hardirq tracing to on when idling
Date: Wed, 28 May 2014 08:46:43 +0200
Message-ID: <4260533.1h2PQ8Ph4h@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53852D96.60006@acm.org>
References: <1401045323-7116-1-git-send-email-minyard@acm.org> <6082113.tHepRBe99K@wuerfel> <53852D96.60006@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:rnGnsloNspuquwCSjqUAmiFgpSrvwKg6x+omg6PMmWd
 8asrV+jCMxT5MxbiPCz/NlKyIbmzN6WjSJYi4EQ+SuKF7nIzw7
 XhC/jlYqdM2MNKwrAq/BWpsOuzX0B4zBnQtvgiEY2Dkpmelpc5
 BIQwFDsBoq5beACaJSAS3XiMfcj4BTmen0SD2sij0t7kS3QBHg
 7zzFNcsPV3f1f65mIgjWK57hhh0TL0mZCs94RrllxbMo348bn3
 gZgvtjA+bCQlrKupY+h9u0zyl4NqSzav9kVtiYNd9l/GHW7O+A
 fZQAhGePhEnfWBS6WfXrmBEcfHlQsMTFMfiPVDp+SYT5NcMe1q
 QCWcgIwO8mO8QyA23uKQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2014 19:28:06 Corey Minyard wrote:
> On 05/27/2014 02:27 PM, Arnd Bergmann wrote:
> > On Tuesday 27 May 2014 11:53:59 Stephen Boyd wrote:
> >> On 05/27/14 11:49, Arnd Bergmann wrote:
> >>> You also commented in that thread about stop_critical_timings()/
> >>> start_critical_timings(). Corey, can you look at that, too? I
> >>> think it's designed to avoid the issue you are seeing but
> >>> for some reason doesn't.
> >> I sent a patch last week to "solve" this problem. I'm not sure if it's
> >> right but it works for me.
> >>
> >> https://lkml.org/lkml/2014/5/19/607
> > I think that one was also wrong, as the intention of the existing
> > stop_critical_timings() function is already to do the same that
> > Corey's patch does, i.e. stop the trace before we go to idle as
> > if we were turning IRQs on.
> >
> > Corey, does it work for you if you replace the new trace_hardirqs_on()
> > you added with time_hardirqs_on() or stop_critical_timing()?
> 
> Well, more information on this.  It turns out that the generic idle loop
> calls stop_critical_timing() and start_critical timing(), so the
> arch_cpu_idle() shouldn't have to.
> 
> However, the idle loop calls rcu_idle_enter() after it calls
> stop_critical_timing(), and that is resetting the critical timing, it
> appears.  It's disabling/enabling interrupts in rcu_idle_enter().  If I
> switch the order of the rcu_idle and critical timing calls, the issue
> goes away.
> 
> Stephen's patch does not seem to be necessary for my issue. I tried with
> the patch applied, too.  It doesn't seem to hurt, at least.  It did not
> fix the problem by itself, though.

Interesting, it looked like the "big hammer" solution to me (compared to
yours) that should deal with the problem in any case.

	Arnd
