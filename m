Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab3HGTWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:22:55 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:60633 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab3HGTWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <1375898048.6848.18.camel@gandalf.local.home>
References: <20130807173606.872055511@goodmis.org>
	<1375898048.6848.18.camel@gandalf.local.home>
Date: Wed, 7 Aug 2013 12:22:53 -0700
X-Google-Sender-Auth: o981qiNv0QMKrMFvAH3Rp9B3i5g
Message-ID: <CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/2] x86/jump labels: Count and display the short
 jumps used
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 10:54 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On another box, using a distro config, I had even better results:
>
> [    2.352448] short jumps: 193
> [    2.355407]  long jumps: 219

.. well, another way of looking at this is to say that all of this
effort saves just 579 bytes.

Yes, maybe some of those bytes are in really hot paths, but the other
side of *that* coin is that the 2-vs-5 byte jump doesn't much matter
if it's already cached.

So I'd vote for not doing this. If we had some simple way to do the
short jumps, I think it would be lovely. Or if we had to parse the ELF
files and do instruction rewriting for various other reasons, and the
jump rewriting was just one small detail.

But using 576 new lines (the diffstat for your patch 1/2 that adds the
infrastructure to do the rewriting) in order to same just about
exactly that many bytes in the binary - the effort just doesn't work
out, imnsho.

              Linus
