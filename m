Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab3LJAsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:48:52 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52510 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3LJAsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:48:51 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-29-52a664f11f86
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 06/14] tools lib traceevent: Get rid of malloc_or_die() in find_event()
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-7-git-send-email-namhyung@kernel.org>
	<20131209110350.GH1242@krava.brq.redhat.com>
Date: Tue, 10 Dec 2013 09:48:49 +0900
In-Reply-To: <20131209110350.GH1242@krava.brq.redhat.com> (Jiri Olsa's message
	of "Mon, 9 Dec 2013 12:03:50 +0100")
Message-ID: <87d2l5ledq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 12:03:50 +0100, Jiri Olsa wrote:
> On Mon, Dec 09, 2013 at 02:34:03PM +0900, Namhyung Kim wrote:
>> Make it return -2 to distinguish malloc allocation failure.
>> 
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/lib/traceevent/parse-filter.c | 17 ++++++++++++++---
>>  1 file changed, 14 insertions(+), 3 deletions(-)
>> 
>> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
>> index e9d17bfcdffd..06e5af9f8fc4 100644
>> --- a/tools/lib/traceevent/parse-filter.c
>> +++ b/tools/lib/traceevent/parse-filter.c
>> @@ -301,7 +301,10 @@ find_event(struct pevent *pevent, struct event_list **events,
>>  		sys_name = NULL;
>>  	}
>>  
>> -	reg = malloc_or_die(strlen(event_name) + 3);
>> +	reg = malloc(strlen(event_name) + 3);
>> +	if (reg == NULL)
>> +		return -2;
>> +
>
> I guess we dont need error defines or enums when this is just
> static function, but at least please add some comment (description)
> of return values like in pevent_filter_match function

Well, probably we can pass the error_str to find_event().

For comments, I think we only add a formal comment on the external APIs.
So it'll look like this:

/* 
 * Returns 0 if succeeded, -1 if not matched or invalid regex,
 * -2 if memory allocation failed.
 */

What do you think?

Thanks,
Namhyung
