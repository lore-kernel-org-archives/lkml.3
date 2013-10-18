Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab3JRGaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 02:30:22 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57401 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3JRGaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 02:30:20 -0400
Date: Fri, 18 Oct 2013 08:30:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
Message-ID: <20131018063017.GE14264@gmail.com>
References: <525BD08C.2080101@t-online.de>
 <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
 <20131014212830.GD5790@linux.vnet.ibm.com>
 <20131014215117.GE13538@localhost.localdomain>
 <20131015064025.GA22672@gmail.com>
 <20131017142458.GG28963@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017142458.GG28963@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Oct 15, 2013 at 08:40:25AM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > I've been thinking that CONFIG_DEBUG_LIST could help. Unfortunately it's 
> > > good to spot list APIs misuse but, if Linus is right, the problem may be 
> > > that the list belongs to an object that has been freed, and I believe 
> > > that won't detect such a thing.
> > 
> > Use-after free should be reliably detectable via CONFIG_DEBUG_PAGEALLOC=y.
> > 
> > A couple of years ago I wrote a list debugging beast that would catch 
> > use-after-free mishaps (sent it to lkml too IIRC), but it was a bit 
> > complex and I never found the time to nurse it upstream.
> 
> Ok, well CONFIG_DEBUG_PAGEALLOC=y should work for list as for anything, 
> right?

Correct - but it adds non-trivial overhead so in some cases it hides 
races.

Thanks,

	Ingo
