Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3JJA2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:28:43 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49418 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab3JJA2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:28:41 -0400
Date: Wed, 9 Oct 2013 17:28:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 tip/core/rcu 07/13] ipv6/ip6_tunnel: Apply
 rcu_access_pointer() to avoid sparse false positive
Message-ID: <20131010002833.GJ5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1381354186-16285-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <1381354949.4971.20.camel@edumazet-glaptop.roam.corp.google.com>
 <20131009215747.GA5790@linux.vnet.ibm.com>
 <1381356624.4971.26.camel@edumazet-glaptop.roam.corp.google.com>
 <20131009223652.GC5790@linux.vnet.ibm.com>
 <1381359077.4971.37.camel@edumazet-glaptop.roam.corp.google.com>
 <20131009225617.GH11709@jtriplet-mobl1>
 <1381360675.4971.45.camel@edumazet-glaptop.roam.corp.google.com>
 <20131009234040.GB14055@jtriplet-mobl1>
 <1381363960.4971.55.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381363960.4971.55.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101000-1344-0000-0000-0000024F2668
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 05:12:40PM -0700, Eric Dumazet wrote:
> On Wed, 2013-10-09 at 16:40 -0700, Josh Triplett wrote:
> 
> > that.  Constructs like list_del_rcu are much clearer, and not
> > open-coded.  Open-coding synchronization code is almost always a Bad
> > Idea.
> 
> OK, so you think there is synchronization code.
> 
> I will shut up then, no need to waste time.

As you said earlier, we should at least get rid of the memory barrier
as long as we are changing the code.

Josh, what would you suggest as the best way to avoid the memory barrier,
keep sparse happy, and not be too ugly?

							Thanx, Paul

