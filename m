Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaAFISW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:18:22 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55678 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaAFIRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:17:54 -0500
X-AuditID: 9c930197-b7c4aae000003d84-87-52ca66b065a9
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 05/21] perf hists: Accumulate hist entry stat based on the callchain
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
	<1387873347-28838-6-git-send-email-namhyung@kernel.org>
	<20140105165831.GE10018@krava.brq.redhat.com>
	<20140105171528.GA12744@krava.brq.redhat.com>
Date: Mon, 06 Jan 2014 17:17:51 +0900
In-Reply-To: <20140105171528.GA12744@krava.brq.redhat.com> (Jiri Olsa's
	message of "Sun, 5 Jan 2014 18:15:28 +0100")
Message-ID: <87bnzped74.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jan 2014 18:15:28 +0100, Jiri Olsa wrote:
> On Sun, Jan 05, 2014 at 05:58:31PM +0100, Jiri Olsa wrote:
>> On Tue, Dec 24, 2013 at 05:22:11PM +0900, Namhyung Kim wrote:
>> > +	/*
>> > +	 * This is for putting parents upward during output resort iff
>> > +	 * only a child gets sampled.  See hist_entry__sort_on_period().
>> > +	 */
>> > +	he->callchain->max_depth = PERF_MAX_STACK_DEPTH + 1;
>> 
>> so you're using callchain struct to hold the entry's stack
>> position for sorting.. I think we could store this info
>> inside hist_entry itself, and omit 'struct callchain_root'
>> size being allocated for hist_entry

I know it's hacky - it's to keep the sorting properly orderes entries
without callchain support Arun requested.  And I think I can add the
callchain support in the next version so it should be cleaned up too.

>> 
>> I checked 'struct hist_entry' and the 'position' entry seems to
>> be abandonned ;-)) or we could use some unused entry (mem_info?)
>> and create some union.

Yes, I also have a plan to cleanup/diet the struct hist_entry. :)

>
> also perhaps above 5 lines should be part of the later commit:
>   perf hists: Sort hist entries by accumulated period

As I said it'll be changed in the next version.

Thanks,
Namhyung
