Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3KYHiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 02:38:54 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61437 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3KYHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 02:38:50 -0500
X-AuditID: 9c93016f-b7b6aae000005fae-be-5292fe88263d
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 04/22] tools lib traceevent: Add jbd2 plugin
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-5-git-send-email-jolsa@redhat.com>
	<1385130477.1747.33.camel@leonhard>
	<20131123035221.73f67ab7@gandalf.local.home>
Date: Mon, 25 Nov 2013 16:38:48 +0900
In-Reply-To: <20131123035221.73f67ab7@gandalf.local.home> (Steven Rostedt's
	message of "Sat, 23 Nov 2013 03:52:21 -0500")
Message-ID: <87fvqlrkvr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Nov 2013 03:52:21 -0500, Steven Rostedt wrote:
> On Fri, 22 Nov 2013 23:27:57 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> [SNIP]
>> > +#define MINORBITS	20
>> > +#define MINORMASK	((1U << MINORBITS) - 1)
>> > +
>> > +#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
>> > +#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
>> > +
>> > +unsigned long long process_jbd2_dev_to_name(struct trace_seq *s,
>> > +					    unsigned long long *args)
>> > +{
>> > +	unsigned int dev = args[0];
>> > +
>> > +	trace_seq_printf(s, "%d:%d", MAJOR(dev), MINOR(dev));
>> > +	return 0;
>> > +}
>> > +
>> > +unsigned long long process_jiffies_to_msecs(struct trace_seq *s,
>> > +					    unsigned long long *args)
>> > +{
>> > +	unsigned long long jiffies = args[0];
>> > +
>> > +	trace_seq_printf(s, "%lld", jiffies);
>> > +	return jiffies;
>> > +}
>> > +
>> > +int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
>> > +{
>> > +	pevent_register_print_function(pevent,
>> > +				       process_jbd2_dev_to_name,
>> > +				       PEVENT_FUNC_ARG_STRING,
>> 
>> Actually the function returns long long not string.  But it seems the
>> current code doesn't care about the return type.
>
> Actually it's not representing what process_jbd2_dev_to_name() returns
> (which will always return unsigned long long), but what
> "jbd2_dev_to_name()" returns that is (was) defined in the kernel. That
> was:
>
> 	const char *jbd2_dev_to_name(dev_t device)
>
> When registering a function to handle, you need to express the
> prototype of that function (not the handler). The third argument is the
> ret_type of that function.

Aha, got it.  Thank you for the explanation.


> But this is interesting, the ret_type doesn't seem to be used in
> event_parse.c. The return value of the callback is only done in
> eval_num_arg() where we could put a warning if the ret_type is not a
> number.

Yes. :)

Thanks,
Namhyung
