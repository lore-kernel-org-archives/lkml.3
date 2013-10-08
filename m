Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab3JHB4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 21:56:55 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46042 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3JHB4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 21:56:51 -0400
X-AuditID: 9c930197-b7bd9ae000006889-0e-52536661b621
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 8/8] perf tools: Get current comm instead of last one
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
	<1380185890-25758-9-git-send-email-namhyung@kernel.org>
	<20131002100149.GB7941@localhost.localdomain>
Date: Tue, 08 Oct 2013 10:56:49 +0900
In-Reply-To: <20131002100149.GB7941@localhost.localdomain> (Frederic
	Weisbecker's message of "Wed, 2 Oct 2013 12:01:51 +0200")
Message-ID: <87wqlole3i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Wed, 2 Oct 2013 12:01:51 +0200, Frederic Weisbecker wrote:
> On Thu, Sep 26, 2013 at 05:58:10PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> At insert time, a hist entry should reference comm at the time
>> otherwise it'll get the last comm anyway.

[SNIP]

>> --- a/tools/perf/util/comm.h
>> +++ b/tools/perf/util/comm.h
>> @@ -16,5 +16,6 @@ struct comm {
>>  void comm__free(struct comm *comm);
>>  struct comm *comm__new(const char *str, u64 timestamp);
>>  const char *comm__str(const struct comm *comm);
>> +void comm__override(struct comm *self, const char *str, u64 timestamp);
>>  
>>  #endif  /* __PERF_COMM_H */
>> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
>> index a2d58e7abdcf..1aa97b012a09 100644
>> --- a/tools/perf/util/hist.c
>> +++ b/tools/perf/util/hist.c
>> @@ -412,6 +412,7 @@ struct hist_entry *__hists__add_mem_entry(struct hists *self,
>>  {
>>  	struct hist_entry entry = {
>>  		.thread	= al->thread,
>> +		.comm = curr_comm(al->thread),
>
> So now that we have an accessor for that, it clashes a bit with existing names.
>
> I suggest we rename thread__comm_curr() -> thread__comm_str()
> And rename curr_comm() -> thread__comm()
>
> Hmm?

Okay, I'll rename and resend.

Thanks,
Namhyung
