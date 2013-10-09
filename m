Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3JIW5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:57:30 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:53095 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3JIW52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:57:28 -0400
X-Greylist: delayed 1592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Oct 2013 18:57:28 EDT
X-Originating-IP: 173.246.103.110
Date: Wed, 9 Oct 2013 15:57:16 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "David S. Miller" <davem@davemloft.net>,
        Thomas Graf <tgraf@suug.ch>, Gao feng <gaofeng@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 tip/core/rcu 05/13] decnet: Apply rcu_access_pointer()
 to avoid sparse false positive
Message-ID: <20131009225716.GI11709@jtriplet-mobl1>
References: <20131009212920.GA15413@linux.vnet.ibm.com>
 <1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1381354186-16285-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131009222842.GD11709@jtriplet-mobl1>
 <20131009224604.GF5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009224604.GF5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 03:46:04PM -0700, Paul E. McKenney wrote:
> On Wed, Oct 09, 2013 at 03:28:42PM -0700, Josh Triplett wrote:
> > On Wed, Oct 09, 2013 at 02:29:38PM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > The sparse checking for rcu_assign_pointer() was recently upgraded
> > > to reject non-__kernel address spaces.  This also rejects __rcu,
> > > which is almost always the right thing to do.  However, the use in
> > > dn_insert_route() is legitimate: It is assigning a pointer to an element
> > 
> > Nit: "uses ... are", not "use ... is". :)
> 
> Don't I already have "use ... is"?

I was suggesting that it needed to change from "use ... is" to "uses ...
are", not the other way around.

- Josh Triplett
