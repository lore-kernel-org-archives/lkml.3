Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaEOFTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:19:43 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40474 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaEOFTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:19:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140514050958.GB9448@gmail.com>
References: <1400036111-7803-1-git-send-email-ast@plumgrid.com>
	<20140513231708.7eb39a38@gandalf.local.home>
	<CAMEtUuzct=k_9f4QTqRf2TG6mFCjpnfTjo+JkHYQDHKj_i2b+A@mail.gmail.com>
	<20140514050958.GB9448@gmail.com>
Date: Wed, 14 May 2014 22:19:37 -0700
Message-ID: <CAMEtUux=StoEADDrJSqQ4p_GMDDq+MjVjHnQsBaLRST5xRLbKA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next] tracing: accelerate tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 10:09 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Alexei Starovoitov <ast@plumgrid.com> wrote:
>
>> On Tue, May 13, 2014 at 8:17 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Tue, 13 May 2014 19:55:11 -0700
>> > Alexei Starovoitov <ast@plumgrid.com> wrote:
>> >
>> >> Tracing filters are parsing user supplied character string and constructing
>> >> a predicate tree. filter_match_preds() was used to walk nodes of the tree to
>> >> simulate matching of boolean expression.
>> >>
>> >
>> > I applied this on top of net-next, from:
>> >
>> >  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>> >  (master branch)
>> >
>> > and got this compile error:
>>
>> Sorry I wasn't clear in the log.
>> This patch depends on JIT patches that were posted separately.
>> Since this one is RFC, I didn't want to mix them.
>> JIT patches:
>> http://patchwork.ozlabs.org/patch/348558/
>> http://patchwork.ozlabs.org/patch/348559/
>> http://patchwork.ozlabs.org/patch/348560/
>
> Might make sense for you to get a korg account and stick such bits
> into Git trees, to ease testing.

it would be an honor. Thank you.

What is the next step for this particular patch?
Sounds like dependency on full net is a showstopper.
I think splitting bpf into small component will clean up
dependency for seccomp as well.
bpf can move into net/bpf/ dir and go via net-next tree.
If Dave is ok with this, I can start hacking.
It looks to be more or less straight forward.
There are few ways to split it. The only contentious piece
is skb_copy_bits(). I think we can come up with something.
