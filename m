Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaIQRRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:17:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36464 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbaIQRRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:17:23 -0400
Date: Wed, 17 Sep 2014 10:17:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Clark Williams <clark.williams@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: unify boost and kthread priorities
Message-ID: <20140917171717.GC4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140915100524.2cd80d2e@sluggy>
 <20140916204156.GP4723@linux.vnet.ibm.com>
 <1410972543.31130.87.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410972543.31130.87.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091717-7164-0000-0000-000004AED610
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 06:49:03PM +0200, Paul Bolle wrote:
> Hi Paul,
> 
> On Tue, 2014-09-16 at 13:41 -0700, Paul E. McKenney wrote:
> > rcu: unify boost and kthread priorities
> > 
> > Rename CONFIG_RCU_BOOST_PRIO to CONFIG_RCU_KTHREAD_PRIO and use this
> > value for both the per-CPU kthreads (rcuc/N) and the rcu boosting
> > threads (rcub/n).
> > 
> > Also, create the module_parameter rcutree.kthread_prio to be used on
> > the kernel command line at boot to set a new value (rcutree.kthread_prio=N).
> > 
> > Signed-off-by: Clark Williams <clark.williams@gmail.com>
> > [ paulmck: Ported to rcu/dev. ]
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This landed in today's linux-next (ie, next-20140917) as commit
> 04a96e05bda6 ("rcu: unify boost and kthread priorities").
> 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> >[...]
> > diff --git a/init/Kconfig b/init/Kconfig
> >[...]
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> >[...]
> 
> There's a reference to CONFIG_RCU_BOOST_PRIO in
> tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt. It needs
> updating too, doesn't it?

Good catch!

Also the one in tools/testing/selftests/rcutorture/configs/rcu/TREE03.

Fixed both, thank you!

							Thanx, Paul

