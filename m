Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3KEHpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:45:01 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63627 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3KEHpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:45:00 -0500
X-AuditID: 9c93016f-b7bc7ae0000010eb-60-5278a1fac731
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 14/14] perf report: Add -g cumulative option
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
	<1383202576-28141-15-git-send-email-namhyung@kernel.org>
	<20131101131734.GG10041@krava.brq.redhat.com>
Date: Tue, 05 Nov 2013 16:44:58 +0900
In-Reply-To: <20131101131734.GG10041@krava.brq.redhat.com> (Jiri Olsa's
	message of "Fri, 1 Nov 2013 14:17:34 +0100")
Message-ID: <87y553xpfp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Nov 2013 14:17:34 +0100, Jiri Olsa wrote:
> On Thu, Oct 31, 2013 at 03:56:16PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The -g cumulative option is for showing accumulated overhead (period)
>> value as well as self overhead.

[SNIP]

>> +static void
>> +sort_chain_cumulative(struct rb_root *rb_root __maybe_unused,
>> +		      struct callchain_root *chain_root __maybe_unused,
>> +		      u64 min_hit __maybe_unused,
>> +		      struct callchain_param *param __maybe_unused)
>> +{
>> +}
>
> maybe add some commentary explaning that it's intentionaly empty
>
> or maybe dont set it and do following check
> in __hists__insert_output_entry:
>
>         if (symbol_conf.use_callchain && callchain_param.sort)
>                 callchain_param.sort(&he->sorted_chain, he->callchain,
>                                       min_callchain_hits, &callchain_param);

Yeah, I'm fine with either way.

Hmm.. but now I think that checking existence of the sort function would
be better than having an empty function.  Will change in v3.

Thanks,
Namhyung
