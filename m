Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3JYIif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:38:35 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:64717 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3JYIid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:38:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
References: <525BD08C.2080101@t-online.de>
	<CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
Date: Fri, 25 Oct 2013 09:38:32 +0100
X-Google-Sender-Auth: noTzNDWiROGvFhA-7VZxI_0DeTg
Message-ID: <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Knut Petersen <Knut_Petersen@t-online.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 6:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And your other oopses do seem to have a similar pattern, even if their
> actual oops is elsewhere. They oops in run_timer_softirq, also taking
> a page fault in the 0xf9...... range, so it might well be a vmalloc
> address there too.

Hmm.. I just got a run_timer_softirq oops on my own laptop, slightly
different. That was not during shutdown, although there was a "yum
upgrade" finishing when that happened, so it's quite likely that there
was a service shutdown (and then restart).

I think it's related. But my oops has almost no information: the IP
that was jumped to was bogus, and the callchain is just CPU idle
followed by the softirq -> run_timers_softirq handling, so there's no
real way to see *what* triggered it.

The bad rip was ffffffffa051e250, which is not a valid code address.
It *might* be a module address, though. So this might be triggered by
rmmod on some module that doesn't remove all its timers...

Ideas?

                 Linus
