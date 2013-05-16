Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab3EPIM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:12:28 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58028
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399Ab3EPIMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:12:23 -0400
Date: Thu, 16 May 2013 10:10:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Don Zickus <dzickus@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
Message-ID: <20130516081027.GD19669@dyad.programming.kicks-ass.net>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
 <20130515150652.GP23604@redhat.com>
 <1368631622.6828.69.camel@gandalf.local.home>
 <20130515165915.GE13916@laptop.home>
 <1368637441.6828.70.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368637441.6828.70.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 01:04:01PM -0400, Steven Rostedt wrote:
> On Wed, 2013-05-15 at 18:59 +0200, Peter Zijlstra wrote:
> 
> > At which point we could run the watchdog without perf_event_task_tick().
> 
> At which point we can drop the disable LOCKUP_DETECTOR when NO_HZ_FULL
> is enabled ;-)
> 

Can we? The thing I'm worried about is RCU (of course!). ISTR we rely on RCU
working in NMI context. AFAIR for RCU to work, we need to come out of out magic
NO_HZ state since that would've put RCU into EQS.

Frederic, PaulMck?
