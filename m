Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaAFLEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:04:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56032 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaAFLEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:04:07 -0500
Date: Mon, 6 Jan 2014 12:03:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/7] sched: cleanup trigger_load_balance
Message-ID: <20140106110351.GE31570@twins.programming.kicks-ass.net>
References: <1388411093-3413-1-git-send-email-daniel.lezcano@linaro.org>
 <20131231162821.GE16438@laptop.programming.kicks-ass.net>
 <52C2FC88.6040903@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C2FC88.6040903@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 06:19:04PM +0100, Daniel Lezcano wrote:
> I understand. Happy new year !

Happy new year to you too! :-)

> ps : the patchset is based on tip/sched/core

Weird; because tip/sched/core as per today looks like:


029632fbb7b7c kernel/sched_fair.c (Peter Zijlstra       2011-10-25 10:00:11 +0200 6872) void trigger_load_balance(struct rq *rq, int cpu)

And your patches assume it looks like:

Patch 1: @@ -6878,7 +6878,7 @@ void trigger_load_balance(struct rq *rq)
Patch 2: @@ -6875,10 +6875,10 @@ void trigger_load_balance(struct rq *rq)
Patch 4:
 void trigger_load_balance(struct rq *rq)
 {
-       int cpu = rq->cpu;
-

Which obviously doesn't quite work..


So I can make it fit.. but I do wonder what I'm missing here..
