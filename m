Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750859AbaLOTQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:16:16 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:38970 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaLOTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:16:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141215163232.GA21962@lerouge>
References: <1418610272-21518-1-git-send-email-fweisbec@gmail.com>
	<1418610272-21518-3-git-send-email-fweisbec@gmail.com>
	<CA+55aFwhEkBc899yMY3KugwF0QGF8r7iM_6+DoYa0RgtApv5aw@mail.gmail.com>
	<20141215163232.GA21962@lerouge>
Date: Mon, 15 Dec 2014 11:16:13 -0800
X-Google-Sender-Auth: BrgypbGZ3jaHdM2-P0z_8uShy7M
Message-ID: <CA+55aFy3NeAFBbu38gOpDiynBa-ipi2QmPn8Aymjko6pxmx7xA@mail.gmail.com>
Subject: Re: [PATCH 2/2] sched: Pull resched loop to __schedule() callers
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 8:32 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> But it may have an impact on some context checkers that rely on in_atomic*()
> which ignore the PREEMPT_ACTIVE value. It shouldn't ignore that though but I
> guess it's a hack for some specific situation.

I think we should remove it. The only reason for it is the scheduler
itself, which used to have the in_atomic() check (ok, still has, it's
just called "in_atomic_preempt_off()").

But yes, if we keep the "mask off PREEMPT_ACTIVE" in in_atomic(), then
we do need to update the counts with "PREEMPT_ACTIVE+1" instead. Or
something like that.

                Linus
