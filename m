Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767Ab3JPWWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:22:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39198 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759672Ab3JPWWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:22:35 -0400
Date: Thu, 17 Oct 2013 00:22:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] sched: Guarantee new group-entities always have
 weight
Message-ID: <20131016222225.GO10651@twins.programming.kicks-ass.net>
References: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
 <20131016181627.22647.47543.stgit@sword-of-the-dawn.mtv.corp.google.com>
 <20131016220122.GM10651@twins.programming.kicks-ass.net>
 <CAPM31RKnCkjL1Rf8_0-9ok_ZMi0G2iQtxi0KWnW4rSbsEtbQbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RKnCkjL1Rf8_0-9ok_ZMi0G2iQtxi0KWnW4rSbsEtbQbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 03:16:44PM -0700, Paul Turner wrote:
> > Hurm.. this gives new groups a massive weight; nr_cpus * NICE_0. ISTR
> > there being some issues with this; or was that on the wakeup path where
> > a task woke on a cpu who's group entity had '0' load because it used to
> > run on another cpu -- I can't remember.
> 
> This could also arbitrarily be MIN_WEIGHT.
> 
> I don't think it actually matters, in practice the set of conditions
> for this weight to ever see use are very specific (e.g. the race
> described above). Otherwise it's always going to be re-initialized (on
> first actual enqueue) to the right value.  (NICE_0_LOAD seemed to make
> sense since this is what you'd "expect" for a new, single thread,
> autogroup/group.)

Fair enough. Thanks!
