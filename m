Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3JYTWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 15:22:36 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40501 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3JYTWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 15:22:30 -0400
Message-ID: <526AC4F3.1020404@gmail.com>
Date: Fri, 25 Oct 2013 13:22:27 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: RFP: Fixing "-ga -ag -g fp -g dwarf" was Re: [PATCHSET 0/8] perf
 tools: Fix scalability problem on callchain merging (v5)
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org> <20131011055829.GA4975@gmail.com> <20131011073448.GA11064@krava.redhat.com> <52581511.2010909@gmail.com> <52581737.8090309@gmail.com> <20131012165319.GB15116@gmail.com> <5259A63B.5050406@gmail.com> <20131013052328.GA22563@gmail.com> <20131025190951.GC1853@ghostprotocols.net>
In-Reply-To: <20131025190951.GC1853@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/13 1:09 PM, Arnaldo Carvalho de Melo wrote:
>>> I think I did with the second follow up patch: -ga -ag -g fp -g
>>> dwarf should all work properly with fp the default for -g.
>
>> Acked-by: Ingo Molnar <mingo@kernel.org>
>
> Can I have this one submitted?
>
> I guess I found it but it was malformed, didn't apply.

Upon further review, Jiri was correct: that patch handles some of the 
old cases fine, but did not handle others. ie., it just moved the bad 
syntax problem around.

Looks like the parse-options code does not handle optional arguments. 
e.g., -g defaults to 'fp' if no argument is given. With the following 
permutations:
-gfoo
-g foo
-g -- foo

the parsing code gets confused on what 'foo' is. It needs some logic for 
callbacks to say 'nope, not my argument' and the option parsing checks 
for an alternative interpretation (e.g., "-gfoo" ?= "-f -o -o" or in the 
case of '-g foo' it means -g is the end of the arguments and foo is the 
first one not processed -- ie., the workload to run).

David

