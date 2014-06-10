Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaFJPFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:05:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaFJPFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:05:31 -0400
Date: Tue, 10 Jun 2014 17:04:55 +0200
From: Marek Polacek <polacek@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Jambor <mjambor@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [PATCH] tell gcc optimizer to never introduce new data races
Message-ID: <20140610150455.GC7335@redhat.com>
References: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
 <20140610145327.GJ6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610145327.GJ6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 04:53:27PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 10, 2014 at 03:23:36PM +0200, Jiri Kosina wrote:
> > +# Tell gcc to never replace conditional load with a non-conditional one
> > +KBUILD_CFLAGS	+= $(call cc-option,--param allow-store-data-races=0)
> > +
> 
> Why do we not want: -fmemory-model=safe? And should we not at the very
> least also disable packed-store-data-races?

Note that the option does not exist, even though it is mentioned in the
documentation.

	Marek
