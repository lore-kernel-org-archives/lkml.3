Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab3HGTr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:47:56 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:47633 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3HGTry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:47:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130807192734.GA8395@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
	<CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
	<20130806154314.GA398@redhat.com>
	<CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com>
	<CA+55aFxt1iqJXW=bsETugWVxj9LwZXkq0FT836YMJVsRP9juEQ@mail.gmail.com>
	<20130807192734.GA8395@redhat.com>
Date: Wed, 7 Aug 2013 12:47:53 -0700
X-Google-Sender-Auth: aU7UYgwqWywwRFHG1NW7oKhE-mY
Message-ID: <CA+55aFw7P7LYNFQzy6nrn9DDn5a0UdYYQNx_7sibShvZPLEcmg@mail.gmail.com>
Subject: Re: [PATCH 0/1] (Was: Linux 3.11-rc4)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 12:27 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I guess Grazvydas only meant the "unnecessary" align/len/type checks.

Yeah, some of them may be a bit questionable, but we don't necessarily
know what each microarchitecture does for unsupported ("undefined")
situations.

Intel actually has a lot of errata for their CPU's that they won't
fix, and they tend to be all about exactly the kinds of things that
the architecture manuals say "don't do this". Things like "TSS segment
crosses a page, and you take a page fault in the middle of a task
switch" etc.

Now, I do agree that the debug registers are *much* less likely to
have those kinds of really subtle issues, so maybe relaxing some of
the tests might be reasonable. I'd be a bit nervous about it, but if
it's *only* the length/alignment, and Intel people can be convinced
that it doesn't result in any nasty undefined behavior (as long as the
address is in user space), maybe we could make that change just to
make it easier for Wine.

But the kernel address checking definitely needs to stay around for
security reasons.

                Linus
