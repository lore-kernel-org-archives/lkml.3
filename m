Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab3J2FuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:50:11 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:63017 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3J2FuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:50:09 -0400
X-AuditID: 9c93017e-b7ca6ae000000e8a-77-526f4c8fa0de
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora>
	<20131023050502.1886.15779.stgit@hemant-fedora>
	<CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
	<20131025125921.GA29424@linux.vnet.ibm.com>
	<20131026095023.GF14237@gmail.com>
Date: Tue, 29 Oct 2013 14:50:07 +0900
In-Reply-To: <20131026095023.GF14237@gmail.com> (Ingo Molnar's message of
	"Sat, 26 Oct 2013 11:50:23 +0200")
Message-ID: <8738nk7hio.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sat, 26 Oct 2013 11:50:23 +0200, Ingo Molnar wrote:
> * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
>
>> Hi Pekka,
>> 
>> > >
>> > > You can now use it in all perf tools, such as:
>> > >
>> > >     perf record -e libc:my_event -aR sleep 1
>> > 
>> > Is there a technical reason why 'perf list' could not show all the
>> > available SDT markers on a system and that the 'market to event'
>> > mapping cannot happen automatically?
>> > 
>> 
>> Technically feasible. But then we would have to parse each of the 
>> libraries and executables to list them. Right? I am not sure if 
>> such a delay is acceptable.
>
> I'd say lets try Pekka's suggestion and make it more palatable if 
> there's complaints about the delay. (SSD systems are becoming 
> dominant and there the search should be reasonably fast.)
>
> We could also make 'perf list' more sophisticated, if invoked 
> naively as 'perf list' then maybe it should first display the 
> various event categories, with a (rough) count:
>
> $ perf list
>    34 hardware events       # use 'perf list --hw'    to list them
>    40 hw-cache events       # use 'perf list --cache' to list them
>    20 software events       # use 'perf list --sw'    to list them
>     2 raw events            # use 'perf list --raw'   to list them
>   120 tracepoints           # use 'perf list --tp'    to list them
>   >10 SDT tracepoints       # use 'perf list --sdt'   to list them
>
>  # use 'perf list -a' to list all events
>  # use 'perf list ./binary' to list events in a given binary
>
> I.e. bring a bit more structure into it.

I like this. :)

Note that 'perf list' already support this kind of filtering now:

  $ perf list hw cache sw tracepoint pmu

or

  $ perf list sched:*

It'd be great if this globbing also supports SDTs.

And for 'perf list ./binary' case, it could detect libraries in the
dependency list and then also scan them.

>
>> Also if a binary exists in a path thats is not covered in the 
>> default search, an user might believe that his binary may not have 
>> markers. I know the above reason is more of a user folly than a 
>> tooling issue.
>
> I think in 99% of the usecases people will either use pre-built 
> markers that come with their distro, or will be intimately aware of 
> the markers because they are in the very app they are developing.
>
> So I wouldn't worry about 'user has a weird binary' case too much.
>
> I agree with Pekka that making them easily discoverable and visible 
> as a coherent whole is really important.

Agreed.  We do need to improve the user experience of the perf tools!

Thanks,
Namhyung
