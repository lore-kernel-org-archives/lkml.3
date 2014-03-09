Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaCITLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 15:11:50 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:45956 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaCITLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 15:11:48 -0400
Message-ID: <1394392306.20149.112.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v7 net-next 1/3] filter: add Extended BPF interpreter
 and converter
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Hagen Paul Pfeifer <hagen@jauu.net>,
        Jesse Gross <jesse@nicira.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Pekka Enberg <penberg@iki.fi>, Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Date: Sun, 09 Mar 2014 12:11:46 -0700
In-Reply-To: <CAMEtUuwYUhA=CKRVxr-8_KdTqzoQVD1OtgayyxX3aO48CTcxZw@mail.gmail.com>
References: <1394320530-3508-1-git-send-email-ast@plumgrid.com>
	 <1394320530-3508-2-git-send-email-ast@plumgrid.com>
	 <1394376353.20149.96.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAMEtUuyB9ZhvwU+Lv5UypXDbgAG02BgdRomF9nOef-GqNAxjww@mail.gmail.com>
	 <1394388699.20149.105.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAMEtUuwYUhA=CKRVxr-8_KdTqzoQVD1OtgayyxX3aO48CTcxZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-09 at 11:57 -0700, Alexei Starovoitov wrote:

> In sk_run_filter_ext() I used "u64 stack[64];", but "u64 stack[60];" is
> safe too, but I didn't want to go into extensive explanation
> of 'magic' 60 number in the first patch, so I just rounded it to 64.
> Since now you understand, I can make it stack[60] now :)

My point was : You should not use 64 or 60 in the C code.

I should not have to ask you why it is safe.

It should be obvious just reading the source code. And so far it is not.

Thats why we use macros and comments at the macro definition.



