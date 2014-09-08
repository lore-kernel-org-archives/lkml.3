Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaIHGe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:34:27 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40605 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaIHGeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:34:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140907.222841.1933004265241590374.davem@davemloft.net>
References: <20140907180737.GA5057@salvia>
	<CAMEtUuxJLDu8AAsZQdtG781vwC8y60Ygdt4ji5tbeyTE8YbWbQ@mail.gmail.com>
	<20140908052329.GA30461@gmail.com>
	<20140907.222841.1933004265241590374.davem@davemloft.net>
Date: Sun, 7 Sep 2014 23:34:23 -0700
Message-ID: <CAMEtUuzfhnKKbyMW8qDk4YxM3X_NWHU6Gkt1DDTSHXhcScXccQ@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 2/2] net: filter: split filter.h and expose
 eBPF to user space
From: Alexei Starovoitov <ast@plumgrid.com>
To: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2014 at 10:28 PM, David Miller <davem@davemloft.net> wrote:
> From: Ingo Molnar <mingo@kernel.org>
> Date: Mon, 8 Sep 2014 07:23:29 +0200
>
>>
>> * Alexei Starovoitov <ast@plumgrid.com> wrote:
>>
>>> > I don't think the speed up of the llvm submission is a good
>>> > argument, this sounds to me similar to the "please apply this
>>> > patch that reserves this new netlink family in
>>> > include/linux/netlink.h, I promise this new subsystem will be
>>> > submitted soon though. Meanwhile this will speed up
>>> > submission of my userspace software to distributions for
>>> > packaging" argument.
>>>
>>> You're not correct here. I'm not saying 'I promise it will be
>>> submitted'. There _were_ already submitted. [...]
>>
>> And this split-up smaller submissions was requested by David
>> Miller, the networking maintainer, so if Pablo wants another
>> submission format, he needs to take it up with David - we can't
>> do both at once obviously.
>
> I think that just because I asked the submission size to be smaller,
> it does not mean that you can submit things before you provide the
> initial user as well.
>
> And how to work that out and keep the submission size reasonable is
> the submitter's problem, not mine.

imo llvm is more than enough for the first user, no?
I think I've explained that it's practically impossible to have
first in-tree user in the first patch. What do you suggest?
I'm listening, but currently I see no way out.
The patch was large. I broke it down. The first patch is as tiny
as it can get, but Pablo is stalling it, like he did for the last year.
Honestly it doesn't feel fair.
When there were technical arguments (like global vs fd) or
(union attr vs long for syscall) I've listened and rewrote things.
Now it doesn't sound technical.
