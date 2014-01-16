Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaAPPsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:48:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40607 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaAPPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:48:08 -0500
Date: Thu, 16 Jan 2014 16:48:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
Message-ID: <20140116154801.GS7572@laptop.programming.kicks-ass.net>
References: <52D64676.4040000@linaro.org>
 <20140115120418.GD31570@twins.programming.kicks-ass.net>
 <52D7E343.40909@linaro.org>
 <20140116141743.GT31570@twins.programming.kicks-ass.net>
 <52D7EAA4.2080208@linaro.org>
 <20140116142546.GU31570@twins.programming.kicks-ass.net>
 <52D7FA85.9020504@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D7FA85.9020504@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 04:28:05PM +0100, Daniel Lezcano wrote:
> On 01/16/2014 03:25 PM, Peter Zijlstra wrote:
> >On Thu, Jan 16, 2014 at 03:20:20PM +0100, Daniel Lezcano wrote:
> >>Already tested. The last commits do not change the issue described above.
> >
> >Bummer, ok, what version of Ubuntu/rsyslogd are you using? I have a
> >laptop around that should have some recent ubuntu on it, let me go find
> >it.
> >
> 
> Removing the lines below fix the issue.
> 
> These changes were introduced by the commit
> d50dde5a10f305253cbc3855307f608f8a3c5f73.
> 
> I don't get the connection between what is supposed to do the patch as
> described in the commit log and these four lines added.

The interface adds:

  sched_attr::sched_nice

And extends __sched_setscheduler() to also set nice values as provided
by the sched_attr, therefore we must check to see if we've got
permission to change the nice value.

