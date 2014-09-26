Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaIZUJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:09:46 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:64108 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbaIZUJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:09:43 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXFb=etdrabEjbKdxKg51ViPXptOC=6CkKwcGS7Jau8nA@mail.gmail.com>
References: <CALCETrVrHHxGo1RkPu+9LVnPo9XY9yYnJzg2ot0zOgoBspzbOQ@mail.gmail.com>
	<CALCETrXFb=etdrabEjbKdxKg51ViPXptOC=6CkKwcGS7Jau8nA@mail.gmail.com>
Date: Fri, 26 Sep 2014 13:09:40 -0700
Message-ID: <CAMEtUuzAuX=PVDtfQiRKgO7h5wx3gsTJUajr8VKsF4FR-d=JDw@mail.gmail.com>
Subject: Re: eBPF verifier thoughts (Re: [PATCH v15 net-next 00/11] eBPF
 syscall, verifier, testsuite)
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 12:51 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Sep 26, 2014 at 12:34 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> To add one more point:
>
> With the current verifier design, it's impossible to write a userspace
> tool that can take an eBPF program and check it.  The verification is
> far too context-dependent for that to be possible.  I won't go so far
> as to say that a userspace tool needs to *exist*, but I strongly
> object to exposing a verification algorithm that *precludes* writing
> such a tool.

that's just not true.
why is it not possible?

> I think that the eBPF program format needs to encode all context
> needed for verification.  Then verification should check that the
> program is compliant with the context and that the context is correct.
> The former could, in principle, be done in userspace, too.

one can have maps and other future objects equally
represented in user space. Nothing stops doing exactly the same
logic there.

> Here, "context" includes the program type (i.e. what type R1 hasis),
> the key and value sizes of all referenced maps, the fact that the maps
> are maps (damnit, "every object implements exactly the same interface
> and is called a 'map'" is a bad type system*), and possible also
> things like the intended stack size and any other relevant details
> about the entry calling convention.

Andy, I'm not sure where you're going with this.
Sounds like you want to redesign the whole thing?
How long it will take?
Did you consider all the cases I did?
I think I understand your concerns. What I don't understand
why you think we cannot address them step by step.
imo what this does covers a ton of use cases.
Some futuristic stuff may be better and may be not.
But here I have it working, tested and proven over many
use cases, whereas some future unclear stuff will take
unknown amount of time to redesign...
