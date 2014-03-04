Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbaCDO3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:29:12 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56962 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757168AbaCDO3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:29:10 -0500
Date: Tue, 4 Mar 2014 14:28:24 +0000
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Jesse Gross <jesse@nicira.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Pekka Enberg <penberg@iki.fi>, Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 1/3] Extended BPF interpreter and converter
Message-ID: <20140304142824.GA1083@localhost.localdomain>
References: <1393910304-4004-1-git-send-email-ast@plumgrid.com>
 <1393910304-4004-2-git-send-email-ast@plumgrid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393910304-4004-2-git-send-email-ast@plumgrid.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If all issues raised by Daniel are addresed:

Acked-by: Hagen Paul Pfeifer <hagen@jauu.net>

But ...

>Future work:
>
>0. seccomp
>
>1. add extended BPF JIT for x86_64
>
>2. add inband old/new demux and extended BPF verifier, so that new programs
>   can be loaded through old sk_attach_filter() and sk_unattached_filter_create()
>   interfaces
>
>3. tracing filters systemtap-like with extended BPF
>
>4. OVS with extended BPF
>
>5. nftables with extended BPF

... this is shit (not your fault). (Jitted) BPF envolved into a direction
which is just not the right way to do it. You try to fix things, bypass
architectural shortcomings of BPF, perf issues because and so on.

The right direction is to write a new general purpose in-kernel interpreter
from scratch. Capability layers should provide an compatible API for BPF and
seccomp. You have the knowledge to do exactly this, you nearly already did
this - you should start this undertake!

-- 
Hagen Paul Pfeifer
