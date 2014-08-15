Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaHOSvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:51:13 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64517 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaHOSvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:51:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuzey7PanznrAguOpvPLxyhgJB++ovE8RNys7srs=EY1qg@mail.gmail.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
 <1407916658-8731-18-git-send-email-ast@plumgrid.com> <CAE40pdf0pNYyazjpdkzxNJi7iC4LOOr_XEu078OUqP_uoCXnHg@mail.gmail.com>
 <CAMEtUuymPDhYBe42i4DJNXsdgZRaq9LuEU_nGSsqrY1FcFHqhQ@mail.gmail.com>
 <CALCETrVH8KXr8uSHAVy5eBsqmi1LjB5QZpboAGcjYswXvW1opA@mail.gmail.com> <CAMEtUuzey7PanznrAguOpvPLxyhgJB++ovE8RNys7srs=EY1qg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 15 Aug 2014 11:50:49 -0700
Message-ID: <CALCETrVhjO5c7ob1vntx031c5RmxRHimkRt1F2EsmzdKB53_NA@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 17/26] tracing: allow eBPF programs to be
 attached to events
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kees Cook <keescook@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15, 2014 10:36 AM, "Alexei Starovoitov" <ast@plumgrid.com> wrote:
>
> On Fri, Aug 15, 2014 at 10:20 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > The downside of this approach is that compat support might be
> > difficult or impossible.
>
> Would do you mean by compat? 32-bit programs on 64-bit kernels?
> There is no such concept for eBPF. All eBPF programs are always
> operating on 64-bit registers.

Doesn't the eBPF program need to know sizeof(long) to read these
fields correctly?  Or am I misunderstanding what the code does?

--Andy
