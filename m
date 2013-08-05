Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3HESvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:51:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305Ab3HESvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:51:50 -0400
Date: Mon, 5 Aug 2013 20:46:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc4
Message-ID: <20130805184625.GA11633@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Felipe Contreras wrote:
>
> I found a regression while running all v3.11-rcX kernels; Starcract II
> through wine crashes. The culprit is fab840f (ptrace: PTRACE_DETACH
> should do flush_ptrace_hw_breakpoint(child)), I revert that commit and
> there's no crash.

Heh. I pulled wine-git.

set_thread_context() does a lot of PTRACE_POKEUSER requests and then
it calls resume_after_ptrace() which simply does PTRACE_DETACH.

I'll recheck tomorrow, but it really looks as if it _wants_ to leak
the debug registers after detach. And more, it does PTRACE_ATTACH
only to set these regs.

And this is exactly what fab840f tries to prevent.

Oleg.

