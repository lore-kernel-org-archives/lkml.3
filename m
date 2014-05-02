Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaEBMvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 08:51:55 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54994 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaEBMvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 08:51:53 -0400
Message-ID: <1399035110.5233.168.camel@marge.simpson.net>
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, morten.rasmussen@arm.com, mingo@kernel.org,
        peterz@infradead.org, george.mccollister@gmail.com,
        ktkhai@parallels.com
Date: Fri, 02 May 2014 14:51:50 +0200
In-Reply-To: <1399030032.5233.142.camel@marge.simpson.net>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
	 <1399011219.5233.55.camel@marge.simpson.net> <53633B81.1080403@redhat.com>
	 <1399016273.5233.94.camel@marge.simpson.net> <536379D0.8070306@redhat.com>
	 <1399030032.5233.142.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 13:27 +0200, Mike Galbraith wrote: 
> On Fri, 2014-05-02 at 06:56 -0400, Rik van Riel wrote: 
> > On 05/02/2014 03:37 AM, Mike Galbraith wrote:
> > > On Fri, 2014-05-02 at 02:30 -0400, Rik van Riel wrote: 
> > >> On 05/02/2014 02:13 AM, Mike Galbraith wrote:
> > >>> On Fri, 2014-05-02 at 00:42 -0400, Rik van Riel wrote:
> > >>>
> > >>>> Whether or not this is the right thing to do remains to be seen,
> > >>>> but it does allow us to verify whether or not the wake_affine
> > >>>> strategy of always doing affine wakeups and only disabling them
> > >>>> in a specific circumstance is sound, or needs rethinking...
> > >>>
> > >>> Yes, it needs rethinking.
> > >>>
> > >>> I know why you want to try this, yes, select_idle_sibling() is very much
> > >>> a two faced little bitch.
> > >>
> > >> My biggest problem with select_idle_sibling and wake_affine in
> > >> general is that it will override NUMA placement, even when
> > >> processes only wake each other up infrequently...
> > > 
> > > Hm, seems the thing to do would be to tell select_task_rq_fair() to keep
> > > it's mitts off of tasks that the numasched stuff has placed rather than
> > > decapitating select_idle_sibling() or some other drastic measure.
> > 
> > Thing is, if tasks are waking each other up frequently enough, we
> > probably DO want to place them near each other with select_idle_sibling.
> 
> Right.  I'm thinking you could perhaps create a sched feature like
> NUMA_ME_HARDER or such so you can tell it to go away if you find that
> your load performs best when movement is left entirely up to the NUMA
> placement code.
> 
> > We just cannot afford to have it as the default behaviour for casual
> > wakeup activity, because it will mess up other things.
> 
> I think it is generally good, but yes, it has its bad it's bad side, why
> we have tweakables.

Slightly garbled (multitasking).

To make that a little clearer, generally, trying to bring waker and
wakee together is a good thing.  I think changing the default to avoid
doing the generally good thing is wrong.  Box drivers should be given
whatever knobs they need to adjust as required, and use them, because
there is no one correct answer.

-Mike

