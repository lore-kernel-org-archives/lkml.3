Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030256Ab3DSKwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:52:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36053 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968143Ab3DSKv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:51:56 -0400
Message-ID: <1366368694.19383.22.camel@laptop>
Subject: Re: [RFC PATCH 0/2] sched: move content out of core files for load
 average
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 19 Apr 2013 12:51:34 +0200
In-Reply-To: <20130419082546.GA25370@gmail.com>
References: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>
	 <20130415093330.GC17715@gmail.com> <1366283681.19383.5.camel@laptop>
	 <51701722.1070407@windriver.com> <20130419082546.GA25370@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 10:25 +0200, Ingo Molnar wrote:
> It might eventually make sense to integrate the 'average load'
> calculation as well 
> with all this - as they really have a similar purpose, the avenload[]
> vector of 
> averages is conceptually similar to the rq->cpu_load[] vector of
> averages.

The /proc/loadavg definition isn't useful for anything remotely sane
wrt load-balancing or otherwise, so I don't really see that integration
happening (its a measure of how many tasks are blocked, where the
load-balancer needs a measure of how many tasks are wanting to run).

But yeah, sched/proc.c or sched/proc_loadavg.c works for me.

