Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbbAVCNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:13:54 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:54641 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbbAVCNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:13:44 -0500
MIME-Version: 1.0
In-Reply-To: <20150121205643.4d8a3516@gandalf.local.home>
References: <CAMEtUux8v2LDtLcgpT9hCvJgnrCwT2fkzsSvAPFSuEUx+itxyQ@mail.gmail.com>
 <20150121205643.4d8a3516@gandalf.local.home>
From: Alexei Starovoitov <ast@plumgrid.com>
Date: Wed, 21 Jan 2015 18:13:23 -0800
Message-ID: <CAMEtUuz9bcaYN0if1w1O01vwc593P2ACUX-KK++6Jeqz7MwFsg@mail.gmail.com>
Subject: Re: [PATCH tip 0/9] tracing: attach eBPF programs to tracepoints/syscalls/kprobe
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 5:56 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 21 Jan 2015 17:49:08 -0800
> Alexei Starovoitov <ast@plumgrid.com> wrote:
>
>
>> > This also makes it keeping events in the soft-disabled state.
>>
>> I was never able to figure out the use case for soft-disabled state.
>> Probably historical before static_key was done.
>
> No, it's not historical at all. The "soft-disable" is a way to enable
> from any context. You can't enable a static key from NMI or interrupt
> context, but you can enable a "soft-disable" there.
>
> As you can enable or disable events from any function that the function
> tracer may trace, I needed a way to enable them (make the tracepoint
> active), but do nothing until something else turns them on.

Thanks for explanation. Makes sense.
Speaking of nmi... I think I will add a check that if (in_nmi())
just skip running the program, since supporting this use
case is not needed at the moment.
