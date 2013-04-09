Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936073Ab3DITf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:35:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935868Ab3DITfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:35:22 -0400
Date: Tue, 9 Apr 2013 21:32:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] uprobes/tracing: uretprobes
Message-ID: <20130409193200.GA26731@redhat.com>
References: <20130329181548.GA20700@redhat.com> <1365436535.25498.12.camel@gandalf.local.home> <20130409145054.GA22913@redhat.com> <1365520045.25498.62.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365520045.25498.62.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Steven Rostedt wrote:
>
> On Tue, 2013-04-09 at 16:50 +0200, Oleg Nesterov wrote:
> > On 04/08, Steven Rostedt wrote:
>
> > OK, will do.
> >
> > Or. Instead of enum we can use "bool is_return". So, instead of
> >
> > 	if (is_ret_probe(tu))
> > 		size = SIZEOF_TRACE_ENTRY(UPROBE_ENTRY_RETPROBE);
> > 	else
> > 		size = SIZEOF_TRACE_ENTRY(UPROBE_ENTRY_NORMAL);
> >
> > we can do
> >
> > 	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
> >
> > What do you like more?
>
> Which ever is easier ;-)
>
> I just hated the magic "1" and "2". As long as I (or any reviewer) does
> not need to go searching for numbers, and can easily figure out what is
> going on by looking at the code at hand, I'm happy.
>
> Both the above satisfy that requirement.
>
> Your "is_ret_probe(tu)" may have the added bonus of being less error
> prone.

OK, please see v2.

Change SIZEOF_TRACE_ENTRY/DATAOF_TRACE_ENTRY to accept "bool is_return"
rather than "int nr".

Srikar, I preserved your acks, hopefully this is fine. But 4/7 still
doesn't have your ack.

Oleg.

