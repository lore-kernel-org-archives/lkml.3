Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3IOTaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 15:30:09 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:20684 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3IOTaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 15:30:07 -0400
Message-ID: <1379273400.2197.71.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/2] ipc/sem.c: Race in sem_lock()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Greg KH <greg@kroah.com>
Date: Sun, 15 Sep 2013 12:30:00 -0700
In-Reply-To: <52359B4E.7060700@colorfullife.com>
References: <1379194496-4642-1-git-send-email-manfred@colorfullife.com>
	 <1379225343.5545.154.camel@marge.simpson.net>
	 <52359B4E.7060700@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-15 at 13:34 +0200, Manfred Spraul wrote:
> Hi all,
> 
> On 09/15/2013 08:09 AM, Mike Galbraith wrote:
> > On Sat, 2013-09-14 at 23:34 +0200, Manfred Spraul wrote:
> >
> >> The bug is probably also present in 3.10 and 3.11, but for these kernels
> >> is is probably simpler just to move the test of sma->complex_count after
> >> the spin_is_locked() test.
> > IMHO, your 6 patch series should go to stable as well.  Scalability is
> > still BAD without them.  Now, you've shown the lock split to be buggy.
> >
> > Logically, the whole thing should be reverted entirely in stable, or
> > fixed up properly.
> Davidlohr: Are you working on fixing the open issues?

I have the patches but we're waiting for input from James to see if we
can use rcu to free the security data, which is probably the best way to
go.

Thanks,
Davidlohr

