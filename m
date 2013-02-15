Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab3BOTpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:45:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab3BOTpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:45:21 -0500
Date: Fri, 15 Feb 2013 20:43:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pedro Alves <palves@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-api@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without
	removing them from a queue
Message-ID: <20130215194356.GA12413@redhat.com>
References: <1360768595-31943-1-git-send-email-avagin@openvz.org> <511E8223.6010506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511E8223.6010506@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Pedro Alves wrote:
>
> Not sure I'm reading the patch right, but it looks like GDB would
> be able to use this as alternative to PTRACE_GET_SIGINFO variant

No, it is different. PTRACE_GETSIGINFO reports the siginfo for the signal
which was already dequeued (ignoring the fact ->last_siginfo != NULL doesn't
necessarily mean we report a signal), while this patch allows to look at
the pending signals which were not reported yet.

> I wouldn't mind if this was added unconditionally
> instead of wrapped on CONFIG_CHECKPOINT_RESTORE.

I agree. If you think gdb can use this new feature,  CONFIG_ can go away.

> We'd miss the poke
> variant, but that looks like something that could be always be added
> later.

Yes. _POKE_ or _QUEUE_ or _DEQUEUE_, we can add more features if user-
space wants them.

Oleg.

