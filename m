Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3FQSdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:33:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52463 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3FQSdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:33:45 -0400
Date: Mon, 17 Jun 2013 20:33:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-mips@linux-mips.org,
        sibyte-users@bitmover.com, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/7] MIPS: sibyte: Add missing sched.h header
Message-ID: <20130617183334.GC3204@twins.programming.kicks-ass.net>
References: <1371477641-7989-1-git-send-email-markos.chandras@imgtec.com>
 <1371477641-7989-4-git-send-email-markos.chandras@imgtec.com>
 <20130617164427.GE10408@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617164427.GE10408@linux-mips.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 06:44:27PM +0200, Ralf Baechle wrote:
> On Mon, Jun 17, 2013 at 03:00:37PM +0100, Markos Chandras wrote:
> 
> > It's needed for the TASK_INTERRUPTIBLE definition.
> > 
> > Fixes the following build problem:
> > arch/mips/sibyte/common/sb_tbprof.c:235:4: error: 'TASK_INTERRUPTIBLE'
> > undeclared (first use in this function)
> 
> Ideally sched.h should be included into the actual user of
> TASK_INTERRUPTIBLE, the wake_up_interruptible macro in <linux/wait.h> but
> that seems way too risky that close to a release.

Oh man, there's include recursion hell waiting for you ;-)
