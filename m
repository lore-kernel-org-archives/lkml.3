Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab3JOHMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:12:41 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54009 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3JOHMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:12:40 -0400
X-AuditID: 9c930179-b7c78ae000003065-c1-525ceae673cb
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf tools: Compare dso's also when comparing symbols
References: <1381802517-18812-1-git-send-email-namhyung@kernel.org>
	<20131015060829.GA4529@gmail.com>
Date: Tue, 15 Oct 2013 16:12:38 +0900
In-Reply-To: <20131015060829.GA4529@gmail.com> (Ingo Molnar's message of "Tue,
	15 Oct 2013 08:08:29 +0200")
Message-ID: <87y55v9fdl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 08:08:29 +0200, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Linus reported that sometimes 'perf report -s symbol' exits without any 
>> message on TUI.  David and Jiri found that it's because it failed to add 
>> a hist entry due to an invalid symbol length.
>
> Btw., 'exit without any messages' is something that should be fixed 
> separately as well I suspect.

Sure.  I believe acme is gonna work on it. :)

>
>>  static int64_t
>>  sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
>>  {
>> +	int64_t ret;
>> +
>
> Btw., this file should go back to u64/s64 like the kernel and most of perf 
> does. (A few int64_t uses slipped into other places as well, I suspect 
> they should be fixed.)

Okay, will send a separate patch for the fix.

Thanks,
Namhyung
