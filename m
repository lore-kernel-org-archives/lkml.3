Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaAQHoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 02:44:11 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49190 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaAQHoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 02:44:10 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-fb-52d8df44e9cb
From: Namhyung Kim <namhyung@kernel.org>
To: Gaurav Jain <gjain@fb.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf tools: Fix JIT profiling on heap
References: <20140116143749.GA21526@ghostprotocols.net>
	<CEFDA8E4.2D359%gjain@fb.com>
Date: Fri, 17 Jan 2014 16:44:04 +0900
In-Reply-To: <CEFDA8E4.2D359%gjain@fb.com> (Gaurav Jain's message of "Thu, 16
	Jan 2014 20:23:27 +0000")
Message-ID: <87sisn6ojf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gaurav,

On Thu, 16 Jan 2014 20:23:27 +0000, Gaurav Jain wrote:
> On 1/16/14, 9:37 AM, "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
> wrote:
>
>>Em Thu, Jan 16, 2014 at 10:49:31AM +0900, Namhyung Kim escreveu:
>>> Gaurav reported that perf cannot profile JIT program if it executes
>>> the code on heap.  This was because current map__new() only handle JIT
>>> on anon mappings - extends it to handle no_dso (heap, stack) case too.
>>> 
>>> This patch assumes JIT profiling only provides dynamic function
>>> symbols so check the mapping type to distinguish the case.  It'd
>>> provide no symbols for data mapping - if we need to support symbols on
>>> data mappings later it should be changed.
>>
>>But we do support symbols in data mappings, that is why we have
>>MAP__VARIABLE, etc, can you elaborate?
>
> Does perf support data mappings from perf map files? Could you please
> share an example of how I may be able to use this.

IIUC there's no difference between function and data mapping.  So you
can use same perf map file for both - in fact there's no way to use
different map file in a single task.  I guess perf will use it to find
only function symbols in function mappings and variables in data
mapping based on the address it accesses.

What I wasn't sure is whether JIT program also produces some dynamic data.
And I think only perf mem command cares about data mappings, no?

Thanks,
Namhyung
