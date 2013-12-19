Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3LSQL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:11:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab3LSQLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:11:23 -0500
Date: Thu, 19 Dec 2013 11:10:45 -0500
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: BUG: MAX_LOCKDEP_ENTRIES too low!
Message-ID: <20131219161045.GC25771@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sasha.levin@oracle.com>,
	Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <52B289F4.7060205@oracle.com>
 <20131219103401.GE30183@twins.programming.kicks-ass.net>
 <52B2FC66.9010309@oracle.com>
 <20131219152002.GK16438@laptop.programming.kicks-ass.net>
 <52B3134D.2010203@oracle.com>
 <20131219155121.GL16438@laptop.programming.kicks-ass.net>
 <20131219155917.GB25771@redhat.com>
 <20131219160116.GC7959@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219160116.GC7959@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 05:01:16PM +0100, Peter Zijlstra wrote:
 > On Thu, Dec 19, 2013 at 10:59:17AM -0500, Dave Jones wrote:
 > > On Thu, Dec 19, 2013 at 04:51:21PM +0100, Peter Zijlstra wrote:
 > >  > On Thu, Dec 19, 2013 at 10:39:57AM -0500, Sasha Levin wrote:
 > >  > > That discusses lockdep classes, which is actually fine in my case. I ran out of
 > >  > > MAX_LOCKDEP_ENTRIES, which isn't mentioned anywhere in Documentation/ .
 > >  > 
 > >  > Yeah, it suffers from the same problem though. Lockdep has static
 > >  > resource allocation and never frees them.
 > >  > 
 > >  > The lock classes are the smallest pool and usually run out first, but
 > >  > the same could happen for the entries, after all, the more classes we
 > >  > have the more class connections can happen.
 > >  > 
 > >  > Anyway, barring a leak and silly class mistakes like mentioned in the
 > >  > document there's nothing we can do except raise the number.
 > > 
 > > I tried this. When you bump it to 32k, it fares better but then you
 > > start seeing "BUG: MAX_LOCKDEP_CHAINS too low!" instead.
 > > I've not tried bumping that yet, as I've stopped seeing these lately
 > > due to hitting more serious bugs first.
 > 
 > What are you doing to trigger all this? I don't see these. Are you
 > loading/unloading modules a lot?

syscall fuzzing.

	Dave

