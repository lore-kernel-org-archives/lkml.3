Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055Ab3LJBVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:21:50 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:45183 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3LJBVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:21:49 -0500
X-AuditID: 9c93017d-b7b46ae000000e86-1a-52a66cac9797
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 04/14] tools lib traceevent: Get rid of malloc_or_die() allocate_arg()
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-5-git-send-email-namhyung@kernel.org>
	<20131209110519.7e9fd95c@gandalf.local.home>
Date: Tue, 10 Dec 2013 10:21:48 +0900
In-Reply-To: <20131209110519.7e9fd95c@gandalf.local.home> (Steven Rostedt's
	message of "Mon, 9 Dec 2013 11:05:19 -0500")
Message-ID: <874n6hlcur.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 11:05:19 -0500, Steven Rostedt wrote:
> On Mon,  9 Dec 2013 14:34:01 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> @@ -409,8 +408,10 @@ create_arg_op(enum filter_op_type btype)
>>  	struct filter_arg *arg;
>>  
>>  	arg = allocate_arg();
>> -	arg->type = FILTER_ARG_OP;
>> -	arg->op.type = btype;
>> +	if (arg) {
>> +		arg->type = FILTER_ARG_OP;
>> +		arg->op.type = btype;
>> +	}
>>  
>>  	return arg;
>>  }
>> @@ -421,8 +422,10 @@ create_arg_exp(enum filter_exp_type etype)
>>  	struct filter_arg *arg;
>>  
>>  	arg = allocate_arg();
>> -	arg->type = FILTER_ARG_EXP;
>> -	arg->op.type = etype;
>> +	if (arg) {
>> +		arg->type = FILTER_ARG_EXP;
>> +		arg->op.type = etype;
>> +	}
>>  
>>  	return arg;
>>  }
>> @@ -433,9 +436,11 @@ create_arg_cmp(enum filter_exp_type etype)
>>  	struct filter_arg *arg;
>>  
>>  	arg = allocate_arg();
>> -	/* Use NUM and change if necessary */
>> -	arg->type = FILTER_ARG_NUM;
>> -	arg->op.type = etype;
>> +	if (arg) {
>> +		/* Use NUM and change if necessary */
>> +		arg->type = FILTER_ARG_NUM;
>> +		arg->op.type = etype;
>> +	}
>>  
>>  	return arg;
>>  }
>> @@ -896,8 +901,10 @@ static struct filter_arg *collapse_tree(struct filter_arg *arg)
>>  	case FILTER_VAL_FALSE:
>>  		free_arg(arg);
>>  		arg = allocate_arg();
>> -		arg->type = FILTER_ARG_BOOLEAN;
>> -		arg->boolean.value = ret == FILTER_VAL_TRUE;
>> +		if (arg) {
>> +			arg->type = FILTER_ARG_BOOLEAN;
>> +			arg->boolean.value = ret == FILTER_VAL_TRUE;
>> +		}
>
> Just a nit, but I wonder if all these would look nicer if we just did:
>
> 	arg = allocate_arg();
> 	if (!arg)
> 		return NULL;
> 	[...]
>
> Instead of doing the work within an if statement.

Sure, no problem.

>
> Also, I prefer if (!arg) over if (arg == NULL), but I'm not going to
> fight over that ;-)

Yeah, it's about preference.  I can do it your way from now on if you
want while as you can see it's more error-prone - but no, I didn't do it
intentionally because of that. ;-)

Thanks,
Namhyung
