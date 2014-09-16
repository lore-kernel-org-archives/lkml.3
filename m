Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaIPWGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:06:55 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64141 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaIPWGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:06:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140916.174901.2174503796369572537.davem@davemloft.net>
References: <CAMEtUuxp6709mdygiQyCqwjv-0kF-CbNOzCCZmKw_mUckF4NZA@mail.gmail.com>
	<20140916.165452.1747695341192703967.davem@davemloft.net>
	<CAMEtUuzy0Hvjr0f4XBrH+FAxaKD7aijnYzDe3-MPrGWe6+MD4Q@mail.gmail.com>
	<20140916.174901.2174503796369572537.davem@davemloft.net>
Date: Tue, 16 Sep 2014 15:06:51 -0700
Message-ID: <CAMEtUux2mLD7X+PFq1kZv893Dg9u2rO6w=HwsOirx-VoYejuQQ@mail.gmail.com>
Subject: Re: [PATCH v12 net-next 03/11] bpf: add lookup/update/delete/iterate
 methods to BPF maps
From: Alexei Starovoitov <ast@plumgrid.com>
To: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
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
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 2:49 PM, David Miller <davem@davemloft.net> wrote:
> From: Alexei Starovoitov <ast@plumgrid.com>
> Date: Tue, 16 Sep 2014 14:23:27 -0700
>
>> no compat layer and type checking will be done
>> by syscall wrappers. Ok?
>
> Why are you against using strong typing just for everything other
> than the user pointer blobs?
>
> I don't understand the resistence to my suggestion to just use
> aligned_u64 instead of "void __user *" in the union members.

All these different variants are ok to me. There are pros and
cons to either approach. I'm not against strong typing.
I just thought it would be cleaner not to use 'union' and
was asking for opinion. That's all. Sure, I will keep 'union'
and only change pointers to __aligned_u64.
