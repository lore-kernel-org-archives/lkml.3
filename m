Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3LPEtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:49:15 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64938 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3LPEtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:49:14 -0500
X-AuditID: 9c93017e-b7c17ae000003961-30-52ae8647abbb
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 13/14] tools lib traceevent: Get rid of die() in some string conversion funcitons
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
	<1386833777-3790-14-git-send-email-namhyung@kernel.org>
	<20131212184147.GE8164@ghostprotocols.net>
	<87y53phah9.fsf@sejong.aot.lge.com>
	<20131213145204.GC29275@ghostprotocols.net>
Date: Mon, 16 Dec 2013 13:49:11 +0900
In-Reply-To: <20131213145204.GC29275@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Fri, 13 Dec 2013 11:52:04 -0300")
Message-ID: <87sitth03c.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Fri, 13 Dec 2013 11:52:04 -0300, Arnaldo Carvalho de Melo wrote:
>> -				str = malloc_or_die(6);
>> +				str = malloc(6);
>> +				if (str == NULL)
>> +					break;
>>  				if (val)
>>  					strcpy(str, "TRUE");
>>  				else
>
> The malloc here can be combined with the strcpy, and the else clause
> gets immediately after:
>
> 				if (asprintf(&str, "%s", "TRUE") < 0)
>
>> @@ -2119,10 +2122,7 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
>>  			break;
>>  		}
>>  
>> -		len = strlen(left) + strlen(right) + strlen(op) + 10;
>> -		str = malloc_or_die(len);
>> -		snprintf(str, len, "(%s) %s (%s)",
>> -			 left, op, right);
>> +		asprintf(&str, "(%s) %s (%s)", left, op, right);
>>  		break;
>
> I was unsure if str was NULL, it is already, at decl site, good :)
>
> All the rest is ok, so its just the malloc + strcpy that remains to be
> converted, do you want me to do it?

Hmm.. did you mean like this?

		str = NULL;
                if (val)
                	asprintf(&str, "TRUE");
                else
                	asprintf(&str, "FALSE");
                return str;

Thanks,
Namhyung
