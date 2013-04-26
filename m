Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3DZXBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 19:01:33 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:39671 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3DZXBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 19:01:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130426162214.GB30716@somewhere>
References: <1366988007-30665-1-git-send-email-fweisbec@gmail.com>
	<1366988007-30665-2-git-send-email-fweisbec@gmail.com>
	<20130426153956.GB3860@linux.vnet.ibm.com>
	<20130426162214.GB30716@somewhere>
Date: Sat, 27 Apr 2013 01:01:30 +0200
Message-ID: <CAFTL4hxe8Rwj7sqo0G_xPisvXB_tMhVSdD+z32aQnJM9A=31WQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] nohz: Select VIRT_CPU_ACCOUNTING_GEN from full
 dynticks config
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/26 Frederic Weisbecker <fweisbec@gmail.com>:
> On Fri, Apr 26, 2013 at 08:39:56AM -0700, Paul E. McKenney wrote:
>> >  config VIRT_CPU_ACCOUNTING_GEN
>> >     bool "Full dynticks CPU time accounting"
>> > -   depends on HAVE_CONTEXT_TRACKING && 64BIT
>> > +   depends on HAVE_CONTEXT_TRACKING && 64BIT && NO_HZ_FULL
>>
>> Do you really want this change?  This prohibits VIRT_CPU_ACCOUNTING_GEN
>> unless NO_HZ_FULL, which means that it can no longer be used in situations
>> where it used to be usable.  My guess is that you want to leave this
>> particular line as it was.
>
> Hmm, this can make sense. This can be used to perform comparisons between
> tick-based and tickless cputime accounting easily.
>
> I'll respin.

So Ingo please pull "timers/nohz-v2" instead. It does the same but
keeps VIRT_CPU_ACCOUNTING_GEN available even without full dynticks
(could be useful when users need something more precise than tick
based cputime accounting.)

HEAD is 8c23b80ec7f1f5405f07bb56c2f8378800ecf401

If you've already pulled the previous branch I'll make a delta instead.

Thanks.
