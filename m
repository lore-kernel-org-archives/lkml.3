Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaHNW2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 18:28:38 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38158 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaHNW2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 18:28:36 -0400
MIME-Version: 1.0
In-Reply-To: <1407916658-8731-4-git-send-email-ast@plumgrid.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<1407916658-8731-4-git-send-email-ast@plumgrid.com>
Date: Thu, 14 Aug 2014 15:28:35 -0700
Message-ID: <CAE40pdcCqu6zBqDgAXBpKHzX=y7hXtz83yEadYTE2yACiqyT3g@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 03/26] bpf: introduce syscall(BPF, ...)
 and BPF maps
From: Brendan Gregg <brendan.d.gregg@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 12:57 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
[...]
> maps can have different types: hash, bloom filter, radix-tree, etc.
>
> The map is defined by:
>   . type
>   . max number of elements
>   . key size in bytes
>   . value size in bytes

Can values be strings or byte arrays? How would user-level bpf read
them? The two types of uses I'm thinking are:

A. Constructing a custom string in kernel-context, and using that as
the value. Eg, a truncated filename, or a dotted quad IP address, or
the raw contents of a packet.
B. I have a pointer to an existing buffer or string, eg a filename,
that will likely be around for some time (>1s). Instead of the value
storing the string, it could just be a ptr, so long as user-level bpf
has a way to read it.

Also, can keys be strings? I'd ask about multiple keys, but if they
can be a string, I can delimit in the key (eg, "PID:filename").
Thanks,

Brendan

-- 
http://www.brendangregg.com
