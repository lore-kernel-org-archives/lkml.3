Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaIHGha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:37:30 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33496 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaIHGh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:37:28 -0400
Date: Mon, 8 Sep 2014 08:37:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: ast@plumgrid.com, pablo@netfilter.org, torvalds@linuxfoundation.org,
        luto@amacapital.net, rostedt@goodmis.org, dborkman@redhat.com,
        hannes@stressinduktion.org, chema@google.com, edumazet@google.com,
        a.p.zijlstra@chello.nl, hpa@zytor.com, akpm@linuxfoundation.org,
        keescook@chromium.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 net-next 2/2] net: filter: split filter.h and expose
 eBPF to user space
Message-ID: <20140908063723.GA8219@gmail.com>
References: <20140907180737.GA5057@salvia>
 <CAMEtUuxJLDu8AAsZQdtG781vwC8y60Ygdt4ji5tbeyTE8YbWbQ@mail.gmail.com>
 <20140908052329.GA30461@gmail.com>
 <20140907.222841.1933004265241590374.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140907.222841.1933004265241590374.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@kernel.org>
> Date: Mon, 8 Sep 2014 07:23:29 +0200
> 
> > 
> > * Alexei Starovoitov <ast@plumgrid.com> wrote:
> > 
> >> > I don't think the speed up of the llvm submission is a 
> >> > good argument, this sounds to me similar to the "please 
> >> > apply this patch that reserves this new netlink family in 
> >> > include/linux/netlink.h, I promise this new subsystem will 
> >> > be submitted soon though. Meanwhile this will speed up 
> >> > submission of my userspace software to distributions for 
> >> > packaging" argument.
> >> 
> >> You're not correct here. I'm not saying 'I promise it will 
> >> be submitted'. There _were_ already submitted. [...]
> > 
> > And this split-up smaller submissions was requested by David 
> > Miller, the networking maintainer, so if Pablo wants another 
> > submission format, he needs to take it up with David - we 
> > can't do both at once obviously.
> 
> I think that just because I asked the submission size to be 
> smaller, it does not mean that you can submit things before you 
> provide the initial user as well.
> 
> And how to work that out and keep the submission size 
> reasonable is the submitter's problem, not mine.

That's a pretty harsh requirement but might be doable 
technically: Alexei, please submit a series that is large enough 
to provide self-sufficient functionality as per Pablo's request,
but is also small and minimal, as per David's request.

If that fails then another route would be to decouple from 
networking initially and create something new and stand-alone in 
kernel/ebpf/ (or any other name really), with tracing and perf 
usecases, with networking integration and code deduplication to 
be done at the end, when there can be no legitimate argument 
about its utility.

Thanks,

	Ingo
