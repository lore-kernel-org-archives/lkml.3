Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3HERRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:17:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab3HERRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:17:06 -0400
Date: Mon, 5 Aug 2013 19:11:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc4
Message-ID: <20130805171142.GA6978@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com> <20130805132948.GA14942@redhat.com> <CAMP44s0iXYjNuSqtCCjBHbbmmrYsKcrRBmD_W_nEiWTxPX1+xQ@mail.gmail.com> <20130805143935.GA18100@redhat.com> <CAMP44s0Q5fCcAwjPWaiz8uVE+BAnQ=YOBxtqNXR6XT1KBApFng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0Q5fCcAwjPWaiz8uVE+BAnQ=YOBxtqNXR6XT1KBApFng@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Felipe Contreras wrote:
>
> On Mon, Aug 5, 2013 at 9:39 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Hmm. It should not crash under strace... please see below.
> >
> >> 953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
> >
> > OK, so it actually uses ptrace ;)
> >
> > PTRACE_ATTACH fails because this child is already traced by strace, I guess.
> >
> > So does Starcraft crash this way? Or does it fail in some other way?
>
> It's crashing just the same.

But then it is not clear how fab840f can make any difference.

wine can not use ptrace when it runs after "strace -f". But, to remind,
I know nothing about wine. Perhaps wine uses some daemons which actually
run/ptrace the workload?

> > And just in case... perhaps wine does some logging too?
>
> Yeah, but there doesn't seem to be anything interesting:
>
> http://bugs.winehq.org/attachment.cgi?id=45489

at least there is certainly nothing interesting for me since
I don't understand this ;) Thanks.

Oleg.

