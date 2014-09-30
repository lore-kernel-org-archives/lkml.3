Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbaI3XPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:15:08 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:40116 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaI3XPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:15:06 -0400
Date: Tue, 30 Sep 2014 19:15:00 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Rik van Riel <riel@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 2/2] sched/fair: leverage the idle state info when
 choosing the "idlest" cpu
In-Reply-To: <542B277D.7050103@redhat.com>
Message-ID: <alpine.LFD.2.11.1409301904150.5311@knanqh.ubzr>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org> <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org> <542B277D.7050103@redhat.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Rik van Riel wrote:

> On 09/04/2014 11:32 AM, Nicolas Pitre wrote:
> > The code in find_idlest_cpu() looks for the CPU with the smallest
> > load. However, if multiple CPUs are idle, the first idle CPU is
> > selected irrespective of the depth of its idle state.
> > 
> > Among the idle CPUs we should pick the one with with the shallowest
> > idle state, or the latest to have gone idle if all idle CPUs are in
> > the same state.  The later applies even when cpuidle is configured
> > out.
> > 
> > This patch doesn't cover the following issues:
> 
> The main thing it does not cover is already running tasks that
> get woken up again, since select_idle_sibling() covers everything
> except for newly forked and newly executed tasks.

True. Now that you bring this up, I remember that Peter mentioned it as 
well.

> I am looking at adding similar logic to select_idle_sibling()

OK thanks.


Nicolas
