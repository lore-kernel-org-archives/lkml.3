Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaCKCFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:05:30 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:33390 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaCKCF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:05:29 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx7rdm9DGOTTgAKTHNkdfrvQYhT9PRs5MhUPr1gQzWEgA@mail.gmail.com>
References: <1394431444-6987-1-git-send-email-ast@plumgrid.com>
	<1394431444-6987-2-git-send-email-ast@plumgrid.com>
	<20140310.215104.2095195123238829635.davem@davemloft.net>
	<CA+55aFx7rdm9DGOTTgAKTHNkdfrvQYhT9PRs5MhUPr1gQzWEgA@mail.gmail.com>
Date: Mon, 10 Mar 2014 19:05:28 -0700
X-Google-Sender-Auth: 5MvFwogqj_vKJXWQflZpKsx7PW0
Message-ID: <CA+55aFwB5Z74+zi5-9O9jPLxZDZDJjioaJa6MSWQjhVEn_hn4Q@mail.gmail.com>
Subject: Re: [PATCH v8 net-next 1/3] filter: add Extended BPF interpreter and converter
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: ast@plumgrid.com, dborkman@redhat.com, Ingo Molnar <mingo@kernel.org>,
        Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Peter Anvin <hpa@zytor.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, Jesse Gross <jesse@nicira.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>, penberg@iki.fi,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 7:02 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So please don't sell "bool" as some kind of panacea. It has at least
> as many problems as it has advantages.

Side note: not that bitfields are all that great either, partly
because gcc tends to occasionally generate absolutely disgusting code
for even simple things, and they have the worse-than-average problems
with byte/bit ordering etc. So quite frankly, often "unsigned int
flags" together with manual accesses is the way to go if you care
about code generation quality. Of course, there's the whole
convenience issue..

          Linus
