Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbaJXShT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 14:37:19 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45827 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825AbaJXShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 14:37:17 -0400
Date: Fri, 24 Oct 2014 11:33:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: Yanko Kaneti <yaneti@declera.com>, Josh Boyer <jwboyer@fedoraproject.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cong Wang <cwang@twopensource.com>, Kevin Fenzi <kevin@scrye.com>,
        netdev <netdev@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: localed stuck in recent 3.18 git in copy_net_ns?
Message-ID: <20141024183323.GX4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1414044566.2031.1.camel@declera.com>
 <20141023122750.GP4977@linux.vnet.ibm.com>
 <20141023153333.GA19278@linux.vnet.ibm.com>
 <20141023195159.GA2331@declera.com>
 <20141023200507.GC4977@linux.vnet.ibm.com>
 <1414100740.2065.2.camel@declera.com>
 <20141023220406.GJ4977@linux.vnet.ibm.com>
 <31920.1414126114@famine>
 <20141024145028.GN4977@linux.vnet.ibm.com>
 <5677.1414174811@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5677.1414174811@famine>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102418-0029-0000-0000-000000E25620
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 11:20:11AM -0700, Jay Vosburgh wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> >On Thu, Oct 23, 2014 at 09:48:34PM -0700, Jay Vosburgh wrote:
> >> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> [...]
> >> >Either way, my patch assumed that 39953dfd4007 (rcu: Avoid misordering in
> >> >__call_rcu_nocb_enqueue()) would work and that 1772947bd012 (rcu: Handle
> >> >NOCB callbacks from irq-disabled idle code) would fail.  Is that the case?
> >> >If not, could you please bisect the commits between 11ed7f934cb8 (rcu:
> >> >Make nocb leader kthreads process pending callbacks after spawning)
> >> >and c847f14217d5 (rcu: Avoid misordering in nocb_leader_wait())?
> >> 
> >> 	Just a note to add that I am also reliably inducing what appears
> >> to be this issue on a current -net tree, when configuring openvswitch
> >> via script.  I am available to test patches or bisect tomorrow (Friday)
> >> US time if needed.
> >
> >Thank you, Jay!  Could you please check to see if reverting this commit
> >fixes things for you?
> >
> >35ce7f29a44a rcu: Create rcuo kthreads only for onlined CPUs
> >
> >Reverting is not a long-term fix, as this commit is itself a bug fix,
> >but would be good to check to see if you are seeing the same thing that
> >Yanko is.  ;-)
> 
> 	Just to confirm what Yanko found, reverting this commit makes
> the problem go away for me.

Thank you!

I take it that the patches that don't help Yanko also don't help you?

							Thanx, Paul

