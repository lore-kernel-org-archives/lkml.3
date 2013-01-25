Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab3AYSgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:36:18 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:52306 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab3AYSgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:36:16 -0500
Date: Fri, 25 Jan 2013 19:36:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] sched: add a tuning knob to allow changing RR tmeslice
Message-ID: <20130125183610.GA31022@gmail.com>
References: <20121108195113.2dd51d43@redhat.com>
 <20130124165955.GA9324@gmail.com>
 <20130124135427.1748d057@redhat.com>
 <20130125081916.GC25314@gmail.com>
 <20130125120256.52733b51@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125120256.52733b51@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clark Williams <williams@redhat.com> wrote:

> > Shouldn't this be in kernel/sched/sched.h instead of the 
> > (already too large) linux/sched.h?
> 
> I don't think that will work be cause kernel/sysctl.c needs 
> the externs and I doubt we want to include 
> kernel/sched/sched.h from there.

Then at least introduce a new include/linux/sched_sysctl.h file 
please, and include it in sysctl.c and move this new knob there?

Other scheduler related sysctl knobs can move there too later 
on, reducing the burden on sched.h.

Thanks,

	Ingo
