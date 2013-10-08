Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3JHV76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 17:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab3JHV75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 17:59:57 -0400
Date: Tue, 8 Oct 2013 17:59:47 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs lockdep trace after unlink
Message-ID: <20131008215947.GA8915@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <20131008212056.GA7467@redhat.com>
 <20131008213910.GX5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008213910.GX5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 02:39:10PM -0700, Paul E. McKenney wrote:
 > On Tue, Oct 08, 2013 at 05:20:56PM -0400, Dave Jones wrote:
 > > I was deleting a kernel tree, when this happened..
 > > RCU, or xfs ?
 > > 
 > > BUG: MAX_LOCKDEP_CHAINS too low!
 > 
 > I have to ask...  What happens when you bump up MAX_LOCKDEP_CHAINS?
 
We eat up a even more memory I guess.

kernel/lockdep_internals.h:#define MAX_LOCKDEP_CHAINS_BITS	15
kernel/lockdep_internals.h:#define MAX_LOCKDEP_CHAINS	(1UL << MAX_LOCKDEP_CHAINS_BITS)

I had to increase MAX_LOCKDEP_ENTRIES on my local tree already because
I was hitting that limit. 

 > There is a patch to avoid an RCU/scheduler/perf deadlock, which may
 > be found below.  But this stack doesn't look to me to be matching that
 > deadlock.

I'll add that to my tree until it gets mainlined.

thanks,

	Dave

