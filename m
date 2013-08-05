Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3HESzC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:55:02 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:42633 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab3HESzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:55:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130805184625.GA11633@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
	<CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
	<20130805184625.GA11633@redhat.com>
Date: Mon, 5 Aug 2013 11:54:59 -0700
X-Google-Sender-Auth: _65G_nj7CE5grvnUbJvKFj6dkmc
Message-ID: <CA+55aFzWcOXfiJGzF1sVgZFaM_hRSF25P2kC2Ga_b0177jfjYA@mail.gmail.com>
Subject: Re: Linux 3.11-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 11:46 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Heh. I pulled wine-git.
>
> set_thread_context() does a lot of PTRACE_POKEUSER requests and then
> it calls resume_after_ptrace() which simply does PTRACE_DETACH.
>
> I'll recheck tomorrow, but it really looks as if it _wants_ to leak
> the debug registers after detach. And more, it does PTRACE_ATTACH
> only to set these regs.
>
> And this is exactly what fab840f tries to prevent.

Ok, so I guess it's effectively the ABI, and we should just make the
rule be that "if you don't want stale breakpoints, then remove the
breakpoints when you detach".

And thus reverting it the right thing to do. Agreed?

               Linus
