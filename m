Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3HEOpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:45:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab3HEOo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:44:59 -0400
Date: Mon, 5 Aug 2013 16:39:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc4
Message-ID: <20130805143935.GA18100@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com> <20130805132948.GA14942@redhat.com> <CAMP44s0iXYjNuSqtCCjBHbbmmrYsKcrRBmD_W_nEiWTxPX1+xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0iXYjNuSqtCCjBHbbmmrYsKcrRBmD_W_nEiWTxPX1+xQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Felipe Contreras wrote:
>
> On Mon, Aug 5, 2013 at 8:29 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Could you please run wine under strace
> >
> >         strace -f -e ptrace -o LOG wine ...
> >
> > and show the result?
>
> Sure.

Thanks.

> Note that the crash might have happened some time before the end
> of the log.

Hmm. It should not crash under strace... please see below.

> 953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)

OK, so it actually uses ptrace ;)

PTRACE_ATTACH fails because this child is already traced by strace, I guess.

So does Starcraft crash this way? Or does it fail in some other way?

And just in case... perhaps wine does some logging too?

Oleg.

