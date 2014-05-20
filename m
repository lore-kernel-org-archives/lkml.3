Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaETTBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:01:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaETTBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:01:53 -0400
Date: Tue, 20 May 2014 12:01:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de
Subject: Re: [PATCH 6/6] ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT})
 standard compliant
Message-Id: <20140520120151.3cc813026fc73fbeb85ba1dc@linux-foundation.org>
In-Reply-To: <537B9F2D.6060606@colorfullife.com>
References: <1400399917-17583-1-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-2-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-3-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-4-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-5-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-6-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-7-git-send-email-manfred@colorfullife.com>
	<20140519154639.5570a30f8b47872a323dcdfd@linux-foundation.org>
	<537B9F2D.6060606@colorfullife.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014 20:30:05 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:

> Hi Andrew,
> 
> On 05/20/2014 12:46 AM, Andrew Morton wrote:
> > On Sun, 18 May 2014 09:58:37 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:
> >
> >> SUSv4 clearly defines how semncnt and semzcnt must be calculated:
> >> A task waits on exactly one semaphore:
> >> The semaphore from the first operation in the sop array that cannot proceed.
> >>
> >> The Linux implementation never followed the standard, it tried to count all
> >> semaphores that might be the reason why a task sleeps.
> >>
> >> This patch fixes that.
> > What are the back-compatibility implications of this change?
> A really good question:
> - there is no application in Fedora that uses GETNCNT or GETZCNT.
> - application that use only single-sop semop() are also safe, the 
> difference only affects complex apps.
> - portable application are also safe, the new behavior is standard 
> compliant.
> 
> But that's it. The old behavior existed in Linux from 0.99.something 
> until now.

OK, thanks - I slurped your thoughts and Michael's into the changelog
for posterity.

> What about adding a WARN_ON_ONCE() if the case where the behavior 
> differs happens?
> Should I write a patch?

That sounds prudent.
