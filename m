Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3J1Iss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:48:48 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35431 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835Ab3J1Isq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:48:46 -0400
X-Sasl-enc: 8R81TBLe+CmUSXVGOvBmTBot5bf4RWybADWKDLbPqsII 1382950124
Message-ID: <526E24EA.2040701@iki.fi>
Date: Mon, 28 Oct 2013 10:48:42 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        "hegdevasant@linux.vnet.ibm.com" <hegdevasant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "anton@redhat.com" <anton@redhat.com>,
        "systemtap@sourceware.org" <systemtap@sourceware.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "aravinda@linux.vnet.ibm.com" <aravinda@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <20131025125921.GA29424@linux.vnet.ibm.com> <F53BA283-A194-4057-8409-27FD3ECFDF2E@iki.fi> <526A8C2B.7000401@gmail.com>
In-Reply-To: <526A8C2B.7000401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 10/25/2013 06:20 PM, David Ahern wrote:
> On 10/25/13 8:20 AM, Pekka Enberg wrote:
>>> Technically feasible. But then we would have to parse each of the
>>> libraries and executables to list them. Right? I am not sure if such a
>>> delay is acceptable.
>>
>> You could do it at 'perf list' time or even build time and cache it. 
>> And add lazy discovery to 'perf record' and friends.
>
> Instead searching all the known files or building a cache, how about 
> just having an option like: perf list <DSO>. perf-record could still 
> do the probe magic behind the scenes.

We probably should also support that. But I don't see why
'perf list' could not tell me about SDT markers in libraries that
are already installed on my system.

The problem I have with all the command line magic is that
while the tracing mechanisms are awesome, they're nearly
impossible to discover even by a power user such as myself
and you almost certainly forget the exact syntax over time.
It's not as if you're tracing all the time.

I wish people remembed how awesome and simple 'perf stat'
and 'perf record' with 'perf report' were compared to oprofile
when the first versions came out. I think much of the nice
perf features are suffering because we're not paying enough
attention how to make them accessible to users.

The proposed SDT marker feature is a good example of that.
I mean, how on earth would I know about the userspace
probes unless I read LKML and know that such a feature
exists? And why would I want to provide mappings for SDT
markers and perf events if I want to trace 'libc:setjmp'?

So I really hope this SDT effort and the ktap effort at least
make some effort in unifying all the nice functionality that's
simple to use and easy to discover. I really, really would
at the end of the day, just 'perf trace' like I 'perf stat' or
'perf record'.

                 Pekka
