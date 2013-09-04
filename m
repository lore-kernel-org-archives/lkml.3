Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965103Ab3IDRxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:53:50 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:57207 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964786Ab3IDRxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:53:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130903132933.GA24955@gmail.com>
References: <20130903132933.GA24955@gmail.com>
Date: Wed, 4 Sep 2013 10:53:47 -0700
X-Google-Sender-Auth: seGha5GRQ4bonq6cJviCi6PhFqI
Message-ID: <CA+55aFyyJpCC0EFfPpGYi+6goWbA+LZbrkFcLNW3x8xYHfKvdQ@mail.gmail.com>
Subject: Re: [GIT PULL] perf changes for v3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r84HrsHf024701

On Tue, Sep 3, 2013 at 6:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest perf-core-for-linus git tree from:

I don't think this is new at all, but I just tried to do a perf
record/report of "make -j64 test" on git:

It's a big perf.data file (1.6G), but after it has done the
"processing time ordered events" thing it results in:

â”Œâ”€Warning:â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚Processed 8672030 events and lost 71 chunks!â”‚
â”‚Check IO/CPU overload!                      â”‚
â”‚                                            â”‚
â”‚                                            â”‚
â”‚Press any key...                            â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

and then it just hangs using 100% CPU time. Pressing any key doesn't
do anything.

It may well still be *doing* something, and maybe it will come back
some day with results. But it sure doesn't show any indication that it
will.

Try this (in a current git source tree: note, by "git" I actually mean
git itself, not some random git repository)::

    perf record -g -e cycles:pp make -j64 test >& out
    perf report

maybe you can reproduce it.

                Linus
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
