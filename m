Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3ILSvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:51:37 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:65058 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab3ILSvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:51:35 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
References: <20130912133855.GA23780@gmail.com>
	<CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
	<CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
Date: Thu, 12 Sep 2013 11:51:34 -0700
X-Google-Sender-Auth: p56g24ZEAq9bRk_laj8NsMcfQy0
Message-ID: <CA+55aFxbjX6T2L2LRfdCVDznjtJTMJAz3QCVyMWXH0y6c=S2kQ@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
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

On Thu, Sep 12, 2013 at 11:10 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But at least the "make install" problem is repeatable, though.

And now this new problem is repeatable too:

  # On a fully built kernel tree
  perf record -g -e cycles:pp make -j

results in

  [ perf record: Woken up 27 times to write data ]
  [ perf record: Captured and wrote 7.980 MB perf.data (~348659 samples) ]
  0x1b4e0 [0]: failed to process type: -1970637019

where that number changes randomly, ie I get

  0x28dc58 [0]: failed to process type: 99257493
  0x4100 [0]: failed to process type: -1144359783
  0x29050 [0]: failed to process type: -972156963
  ..

looks like perhaps some uninitialized variable somewhere?

Recording performance profiles of other (simpler?) loads still seems
to work. So it's something about that "make -j" that makes it crap out
(note that the tree is fully built, so not a lot actually gets *done*,
and the thing only takes a few seconds)

               Linus
