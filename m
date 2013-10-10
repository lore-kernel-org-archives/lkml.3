Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3JJInJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:43:09 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43534 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3JJInG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:43:06 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-f5-525668983c30
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 50/52] tools/perf/build: Fix O=/some/dir perf.o type of targets
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-51-git-send-email-mingo@kernel.org>
	<87fvs9iqfz.fsf@sejong.aot.lge.com> <20131010063917.GB10159@gmail.com>
Date: Thu, 10 Oct 2013 17:43:04 +0900
In-Reply-To: <20131010063917.GB10159@gmail.com> (Ingo Molnar's message of
	"Thu, 10 Oct 2013 08:39:18 +0200")
Message-ID: <87eh7tcy93.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 10 Oct 2013 08:39:18 +0200, Ingo Molnar wrote:
> Yes, this is a limitation: it will only do the redirection if the source 
> repository is clean.
>
> I don't see a simple solution for that, do you?
>
>> > +util/%.o: $(OUTPUT)util/%.o
>> > +	@echo "    # Redirected target $@ => $(OUTPUT)util/$@"
>> > +bench/%.o: $(OUTPUT)bench/%.o
>> > +	@echo "    # Redirected target $@ => $(OUTPUT)bench/$@"
>> > +tests/%.o: $(OUTPUT)tests/%.o
>> > +	@echo "    # Redirected target $@ => $(OUTPUT)tests/$@"
>> > +endif
>> 
>> It also doesn't care about other directories - arch/, scripts/ and ui/ - 
>> and their subdirectories.  So even on clean build it'll failed to build 
>> these files with O=dir.
>
> Correct - only tried to cover the most common cases. Could add all the 
> other directories if this is something people would like to use on a 
> regular basis.

I don't think it's a common usecase.

>
> I also attempted to do a generic rule that can see into subdirectories, 
> using secondary expansion rules, but my first few attempts failed at 
> producing anything usable ;-) My Make fu still needs working on. 
> Suggestions welcome!

Well, my make fu (make skill?) is also poor. ;)

I'll try to do something about it though.

Thanks,
Namhyung
