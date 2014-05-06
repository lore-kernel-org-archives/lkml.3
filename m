Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaEFTap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:30:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:32736 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751170AbaEFTao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:30:44 -0400
Date: Tue, 6 May 2014 15:30:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Javi Merino <javi.merino@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH] tracing: Add __cpumask() macro to trace events to
 record cpumasks
Message-ID: <20140506153041.464a67db@gandalf.local.home>
In-Reply-To: <484888063.12149.1399403794855.JavaMail.zimbra@efficios.com>
References: <1399377998-14870-1-git-send-email-javi.merino@arm.com>
	<1399377998-14870-6-git-send-email-javi.merino@arm.com>
	<20140506132238.22e136d1@gandalf.local.home>
	<484888063.12149.1399403794855.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 19:16:34 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- Original Message -----
> > From: "Steven Rostedt" <rostedt@goodmis.org>
> > To: "LKML" <linux-kernel@vger.kernel.org>
> > Cc: "Javi Merino" <javi.merino@arm.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Mathieu Desnoyers"
> > <mathieu.desnoyers@efficios.com>, "Ingo Molnar" <mingo@kernel.org>, "Namhyung Kim" <namhyung@kernel.org>, "Jiri
> > Olsa" <jolsa@redhat.com>
> > Sent: Tuesday, May 6, 2014 1:22:38 PM
> > Subject: [RFC][PATCH] tracing: Add __cpumask() macro to trace events to record cpumasks
> > 
> > 
> > Being able to show a cpumask of events can be useful as some events
> > may affect only some CPUs. There is no standard way to record the
> > cpumask and converting it to a string is rather expensive during
> > the trace as traces happen in hotpaths. It would be better to record
> > the raw event mask and be able to parse it at print time.
> 
> Why name the type cpumask especially ? The type could be a "bitmask",
> and the specific field semantic in this case (field name) could
> be "cpus", thus implying that this is a cpu mask. This would allow
> using bitmasks for other things than cpu masks.

Hmm, sure, perhaps it would be better to call it bitmask instead. It
basically is already.

> 
> Moreover, I've been thinking about eventually adding a bitmask associated
> with an enumeration, so each bit of the bitmask could be associated with
> an entry from an enumeration (a string). So having a bitmask type would
> be a good step in that direction. For instance, the block layer
> instrumentation could use this for the rwbs field, instead of
> printing characters with blk_fill_rwbs(). This would save space and
> cpu time at trace collection.

Perhaps.

-- Steve


