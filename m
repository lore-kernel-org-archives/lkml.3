Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab3HGMFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 08:05:41 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37891 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab3HGMFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 08:05:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130806154314.GA398@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
	<CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
	<20130806154314.GA398@redhat.com>
Date: Wed, 7 Aug 2013 15:05:37 +0300
Message-ID: <CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com>
Subject: Re: [PATCH 0/1] (Was: Linux 3.11-rc4)
From: Grazvydas Ignotas <notasas@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>
Content-Type: text/plain; charset=ISO-8859-13
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 6:43 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Felipe, thanks a lot. Yes fab840f is wrong, this "bug" is already
> used as a feature.
>
> Grazvydas, I cc'ed you because I do not really understand
> set_thread_context(). It does a couple of extra PTRACE_POKEUSER's
> with the "Linux 2.6.33+ needs ..." comment. It would be nice if you
> can check if 3.11 still needs this, in this case we probably need
> some more minor fixes in this area.
>
> In fact the first comment doesn't look right, when I look at 2.6.33
> it seems that POKEUSER(DR0-DR6) should be fine without POKEUSER(DR7),
> but this doesn't really matter and I can be easily wrong. Anyway
> this looks like a workaround to hide kernel bugs, I will appreciate
> it if you can tell if wine still needs it or not.

It's not that wine needs all this, it's the Windows games that use
debug registers to store random values to them for their copy
protection stuff. Older Linux kernels used to not care, but newer ones
started validating what's written to debug registers, and those games
started to break under wine. My wine commits try to sidestep these
kernel restrictions/sanity checking.

Personally I'd say the kernel should not limit what's written to debug
registers. Why can't I write insane values to registers in _my_
hardware? It's not like it's going to break the hardware or anything.

-- 
Graþvydas
