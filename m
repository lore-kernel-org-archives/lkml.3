Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbaDHSNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:13:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46359 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbaDHSNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:13:15 -0400
Date: Tue, 8 Apr 2014 20:13:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Stancek <jstancek@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
Message-ID: <20140408181305.GT10526@twins.programming.kicks-ass.net>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
 <CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
 <CA+55aFyfKOv59hptv9rEcf31X5O8s26z+S8f-MchM1C0WtXx3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyfKOv59hptv9rEcf31X5O8s26z+S8f-MchM1C0WtXx3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 10:33:55AM -0700, Linus Torvalds wrote:
> Hmm. And let's think about that powerpc race, where "spin_is_locked()"
> can be false when somebody is waiting to get the lock..

Right; so in the original discussion I never really got to why that is a
problem. A pending waiter cannot modify the wait list, so either we see
the current holder, or we see a stable list.

So I had to hop on a plane while that discussion was happening and while
I did briefly task to Davidlohr in Napa his explanation didn't stick in
my jet-leg addled brain.

Afterwards the discussion got lost in the pile of unread mail.

I'll go re-read that discussion and look up this thread to see if
things will start to make sense.
