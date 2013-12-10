Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3LJBum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:50:42 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46025 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab3LJBuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:50:40 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-43-52a6736e5674
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 14/14] tools lib traceevent: Get rid of die() in some string conversion funcitons
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-15-git-send-email-namhyung@kernel.org>
	<20131209112410.2ca63d45@gandalf.local.home>
Date: Tue, 10 Dec 2013 10:50:38 +0900
In-Reply-To: <20131209112410.2ca63d45@gandalf.local.home> (Steven Rostedt's
	message of "Mon, 9 Dec 2013 11:24:10 -0500")
Message-ID: <87r49ljwy9.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 11:24:10 -0500, Steven Rostedt wrote:
> On Mon,  9 Dec 2013 14:34:11 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> @@ -2231,12 +2238,13 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
>>  		op = "^";
>>  		break;
>>  	default:
>> -		die("oops in exp");
>> +		break;
>>  	}
>
> This looks like we silently ignored the warning. Perhaps we should have:
>
> 	default:
> 		op = "[ERROR IN EXPRESSION TYPE]";
> 		break;

Ah, looks better. :)

Thanks,
Namhyung
