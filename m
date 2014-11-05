Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaKEWoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:44:22 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:54101 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaKEWoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:44:21 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: Replace seq_printf by simpler equivalents
Organization: D03
References: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
	<1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
	<20141105173454.7aa47289@gandalf.local.home>
X-Hashcash: 1:20:141105:rostedt@goodmis.org::gN876Z2KedUtu7Dd:0000000000000000000000000000000000000000001mUy
X-Hashcash: 1:20:141105:linux-kernel@vger.kernel.org::quQNdEr3B2Sbu+un:0000000000000000000000000000000002V5Q
X-Hashcash: 1:20:141105:julia.lawall@lip6.fr::o6/cnuLYJqHYnSLk:0000000000000000000000000000000000000000047R3
X-Hashcash: 1:20:141105:mingo@redhat.com::n19aH5SFQAB5RjHR:05moU
Date: Wed, 05 Nov 2014 23:44:17 +0100
In-Reply-To: <20141105173454.7aa47289@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 5 Nov 2014 17:34:54 -0500")
Message-ID: <87tx2de08u.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05 2014, Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 12 Sep 2014 11:25:52 +0200
> Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 5916a8e..7b9ce28 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -556,13 +556,13 @@ static int function_stat_cmp(void *p1, void *p2)
>>  static int function_stat_headers(struct seq_file *m)
>>  {
>>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> -	seq_printf(m, "  Function                               "
>> -		   "Hit    Time            Avg             s^2\n"
>> -		      "  --------                               "
>> -		   "---    ----            ---             ---\n");
>> +	seq_puts(m,
>> +		 "  Function                               " "Hit    Time            Avg             s^2\n"
>> +		 "  --------                               " "---    ----            ---             ---\n");
>
> Please keep the original format. I know that it's considered bad form
> to split strings like this, but I consider this one of the exceptions
> to the rule.

OK. Want me to resend?

>> @@ -3250,7 +3250,7 @@ static int t_show(struct seq_file *m, void *v)
>>  	if (!t)
>>  		return 0;
>>  
>> -	seq_printf(m, "%s", t->name);
>> +	seq_puts(m, t->name);
>
> This is wrong and dangerous.
>
> What happens if "t->name" contains "%d" or "%s"?

Then those characters will be printed to the seq_file, just as they
would previously? puts doesn't interpret its string argument in any
way...

>> --- a/kernel/trace/trace_events_trigger.c
>> +++ b/kernel/trace/trace_events_trigger.c
>> @@ -373,7 +373,7 @@ event_trigger_print(const char *name, struct seq_file *m,
>>  {
>>  	long count = (long)data;
>>  
>> -	seq_printf(m, "%s", name);
>> +	seq_puts(m, name);
>
> Again, this is wrong and dangerous.

I'm pretty sure it's neither :-)

Rasmus
