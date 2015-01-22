Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbbAVB4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:56:53 -0500
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:55255 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752560AbbAVB4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:56:47 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2904:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3871:3872:3873:3874:4250:5007:6261:6742:7875:10004:10400:10848:10967:11232:11658:11914:12296:12517:12519:12740:13069:13255:13311:13357:13618:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nest13_75282ad30ff11
X-Filterd-Recvd-Size: 1981
Date: Wed, 21 Jan 2015 20:56:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 0/9] tracing: attach eBPF programs to
 tracepoints/syscalls/kprobe
Message-ID: <20150121205643.4d8a3516@gandalf.local.home>
In-Reply-To: <CAMEtUux8v2LDtLcgpT9hCvJgnrCwT2fkzsSvAPFSuEUx+itxyQ@mail.gmail.com>
References: <CAMEtUux8v2LDtLcgpT9hCvJgnrCwT2fkzsSvAPFSuEUx+itxyQ@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 17:49:08 -0800
Alexei Starovoitov <ast@plumgrid.com> wrote:


> > This also makes it keeping events in the soft-disabled state.
> 
> I was never able to figure out the use case for soft-disabled state.
> Probably historical before static_key was done.

No, it's not historical at all. The "soft-disable" is a way to enable
from any context. You can't enable a static key from NMI or interrupt
context, but you can enable a "soft-disable" there.

As you can enable or disable events from any function that the function
tracer may trace, I needed a way to enable them (make the tracepoint
active), but do nothing until something else turns them on.

-- Steve

