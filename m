Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaBBT2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 14:28:25 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:33723 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaBBT2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 14:28:23 -0500
MIME-Version: 1.0
In-Reply-To: <20140202111552.GA2221@ls3530.box>
References: <20140201202320.GA1313@p100.box>
	<CAFLxGvy7vbKmQzyNvTbk35DX5cFGS99CE=nYE_Q0c=LVuD1x9A@mail.gmail.com>
	<20140202111552.GA2221@ls3530.box>
Date: Sun, 2 Feb 2014 11:28:22 -0800
X-Google-Sender-Auth: -Yu4jEkWZtKVT2RLV_FIMvWvVIo
Message-ID: <CA+55aFyoR0DHsbJ8qaE5mEmveZwnxDpxapXZdxHZ-BJnE0CDLQ@mail.gmail.com>
Subject: Re: [GIT PULL] parisc updates for v3.14
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Helge Deller <deller@gmx.de>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 2, 2014 at 3:15 AM, Helge Deller <deller@gmx.de> wrote:
>
> Anyway, the suggested & untested patch below should fix the metag arch
> to cope which my changes to fs/exec.c
> ...
> -#define STACK_RND_MASK (0)
> +#define STACK_RND_MASK (-1)

I don't think that works. That completely breaks randomize_stack_top().

So I'm not going to pull the parisc tree, this needs to be resolved sanely.

In fact, I think that change to fs/exec.c is just completely broken:

+       /* add some more stack size for stack randomization */
+       stack_base += STACK_RND_MASK + 1;

and that "+1" just doesn't make sense, and fundamentally breaks STACK_RND_MASK.

It also seems to be entirely pointless, since the PAGE_ALIGN() that
comes right afterwards will effectively do it anyway.

So NAK on that whole fs/exec.c change. Afaik it's just wrong, and it's stupid.

                  Linus
