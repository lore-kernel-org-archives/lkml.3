Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3KSCat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:30:49 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:64552 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3KSCaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:30:46 -0500
X-AuditID: 9c93017d-b7b24ae000002834-0b-528acd556d7f
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
	<1384267617-3446-5-git-send-email-dsahern@gmail.com>
	<20131112145707.GV5056@laptop.programming.kicks-ass.net>
	<20131112150751.GA19321@ghostprotocols.net>
	<20131112151944.GX5056@laptop.programming.kicks-ass.net>
	<52824AE3.4050207@gmail.com> <20131112211121.GC25913@gmail.com>
	<20131113113439.GI21461@twins.programming.kicks-ass.net>
	<52864ED1.1080607@gmail.com>
	<20131118090117.GE3866@twins.programming.kicks-ass.net>
	<20131118094036.GA26251@gmail.com> <877gc5utkf.fsf@sejong.aot.lge.com>
	<528AB229.6030603@gmail.com> <87wqk5t9yd.fsf@sejong.aot.lge.com>
	<528ACA41.4030202@gmail.com>
Date: Tue, 19 Nov 2013 11:30:45 +0900
In-Reply-To: <528ACA41.4030202@gmail.com> (David Ahern's message of "Mon, 18
	Nov 2013 19:17:37 -0700")
Message-ID: <87ob5ht962.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013 19:17:37 -0700, David Ahern wrote:
> On 11/18/13, 7:13 PM, Namhyung Kim wrote:
>> I think it should be
>>
>>    perf record -e cycles -F 4000 -e faults -c 1 --call-graph dwarf,8192 -a -- sleep 1
>>
>> (at least to generate the feedback spiral more efficiently..)
>
> you don't need the cycles. faults by itself works. Each event contains
> 2 pages of data in the sample. With mmap-based output a single
> sample (1 page fault in any process) generates 2-3 page faults by perf
> which cause 2-3 >8k samples to be generated, which generates faults,
> ....

But after perf touches all pages in ring-buffer and stack, it won't
generate page-faults for itself anymore, right?

Hmm.. thinking it again, perf has all ring-buffer pages in memory when
mmap() called, right?  If so why not doing something like MAP_POPULATE
so that it doesn't need to generate minor-faults?

Thanks,
Namhyung
