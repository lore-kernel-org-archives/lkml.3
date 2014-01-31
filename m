Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbaAaU3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:29:21 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60579 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932460AbaAaU3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:29:17 -0500
X-Sasl-enc: 5SS8IKC0WacZzZikIc53RP+tp2LjZnpYqtiNBr5S6FFz 1391200155
Message-ID: <52EC0795.1040506@iki.fi>
Date: Fri, 31 Jan 2014 22:29:09 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Gaurav Jain <gjain@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf tools: Fix JIT profiling on heap
References: <1389836971-3549-1-git-send-email-namhyung@kernel.org> <52EB8E03.1030505@iki.fi> <20140131150415.GA26494@ghostprotocols.net>
In-Reply-To: <20140131150415.GA26494@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 05:04 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 31, 2014 at 01:50:27PM +0200, Pekka Enberg escreveu:
>> On 01/16/2014 03:49 AM, Namhyung Kim wrote:
>>> Gaurav reported that perf cannot profile JIT program if it executes
>>> the code on heap.  This was because current map__new() only handle JIT
>>> on anon mappings - extends it to handle no_dso (heap, stack) case too.
>>>
>>> This patch assumes JIT profiling only provides dynamic function
>>> symbols so check the mapping type to distinguish the case.  It'd
>>> provide no symbols for data mapping - if we need to support symbols on
>>> data mappings later it should be changed.
>>>
>>> Reported-by: Gaurav Jain <gjain@fb.com>
>>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> Looks OK to me.  Gaurav, does this fix your problem?
> Yes, he tested it, etc, its already in Linus' tree:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/tools/perf/util/map.c?id=578c03c86fadcc6fd7319ddf41dd4d1d88aab77a

Oh, great! I was going through my inbox and didn't notice it because I 
got dropped from the CC list. :-)

Thanks Arnaldo!

                             Pekka
