Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaGWNlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:41:22 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47953 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaGWNlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:41:21 -0400
Date: Wed, 23 Jul 2014 06:41:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/16] rcu: Remove redundant check for an online CPU
Message-ID: <20140723134116.GP11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-5-git-send-email-bobby.prani@gmail.com>
 <20140723120907.GG11241@linux.vnet.ibm.com>
 <CAJhHMCAQ7+HzXfH7E3LNbUVG_zf-1edj6yPBHQ9wtbTrBAoa7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCAQ7+HzXfH7E3LNbUVG_zf-1edj6yPBHQ9wtbTrBAoa7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072313-0928-0000-0000-00000392DEC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 09:23:47AM -0400, Pranith Kumar wrote:
> On Wed, Jul 23, 2014 at 8:09 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Jul 23, 2014 at 01:09:41AM -0400, Pranith Kumar wrote:
> >> rcu_prcess_callbacks() is the softirq handler for RCU which is raised from
> >> invoke_rcu_core() which is called from __call_rcu_core().
> >>
> >> Each of these three functions checks if the cpu is online. We can remove the
> >> redundant ones. This commit removes one of these redundant check.
> >>
> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >
> > Sorry, but no.  There can be a long delay between raise_softirq() and
> > this function starting, particularly if ksoftirqd gets involved.  The
> > CPU could easily go offline in the meantime.
> >
> 
> That makes sense. I guess one of the other two checks in
> __call_rcu_core() or invoke_rcu_core() can go then?

What would have to be the case for this suggested change to be safe?
Does that condition in fact hold?

							Thanx, Paul

