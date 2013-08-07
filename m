Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3HGR1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:27:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab3HGR1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:27:47 -0400
Date: Wed, 7 Aug 2013 19:22:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH 0/1] (Was: Linux 3.11-rc4)
Message-ID: <20130807172208.GA2122@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com> <20130806154314.GA398@redhat.com> <CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Grazvydas Ignotas wrote:
>
> It's not that wine needs all this, it's the Windows games that use
> debug registers to store random values to them for their copy
> protection stuff.

Thanks.

> My wine commits try to sidestep these
> kernel restrictions/sanity checking.

My point was, it seems that starting from 3.11 you can remove both
extra PTRACE_POKEUSER's. Unless, of course, the initial state of dr7
doesn't match dr0 - dr6 set_thread_context() is going to update.

Anyway I agree this interface is very confusing and inconvenient.

And just in case, it is not that I think set_thread_context() should
be changed, I am just wondering whether the kernel still has the bugs
which should be fixed.

> Personally I'd say the kernel should not limit what's written to debug
> registers. Why can't I write insane values to registers in _my_
> hardware? It's not like it's going to break the hardware or anything.

Even if this is safe (and btw I have no idea if this is always true or
not ;), how a user can notice the error then?

Oleg.

