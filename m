Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3BFPDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:03:22 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:63805 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab3BFPDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:03:21 -0500
MIME-Version: 1.0
In-Reply-To: <20130206114925.GF8696@gmail.com>
References: <20130204171817.GA18332@linux.vnet.ibm.com>
	<20130204180734.GA10022@gmail.com>
	<20130204193041.GA16853@gmail.com>
	<20130204202523.GZ2632@linux.vnet.ibm.com>
	<20130205141124.GA12785@linux.vnet.ibm.com>
	<20130206114925.GF8696@gmail.com>
Date: Wed, 6 Feb 2013 16:03:19 +0100
Message-ID: <CAFTL4hyOL9FKwaYDpvmJfrPS-2Uc2cmKVs5DUs9wYoEt=DHifw@mail.gmail.com>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.9
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        rostedt@goodmis.org, rbraun@sceen.net, zhong@linux.vnet.ibm.com,
        markus@trippelsdorf.de, sasha.levin@oracle.com,
        cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/6 Ingo Molnar <mingo@kernel.org>:
>
> btw., I got a non-trivial conflicts in
> kernel/context_tracking.c, with the following commits
> interacting between the RCU tree (tip:core/rcu) and the
> scheduler tree (tip:sched/core):
>
>  6a61671bb2f3 cputime: Safely read cputime of full dynticks CPUs
>  abf917cd91cb cputime: Generic on-demand virtual cputime accounting
>  4eacdf18374e context_tracking: Add comments on interface and internals
>  95a79fd458b8 context_tracking: Export context state for generic vtime
>
> I think I managed to resolve the conflicts (will push it out in
> an hour or two, after some testing) - but please double check me
> on it...

Sorry about that conflict. Given that both RCU and cputime were
competing with significant changes on this newborn subsystem, such
clash was hard to avoid.

The merge is mostly correct. There is just a small issue with
context_tracking_task_switch() kerneldoc style comment: it should be
moved out of guest_enter/guest_exit, newly introduced APIs, to be
right above context_tracking_task_switch() function. Otherwise it's
fine.

Thanks!
