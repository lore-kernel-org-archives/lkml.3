Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaIQSZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:25:47 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41069 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbaIQSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:25:45 -0400
Date: Wed, 17 Sep 2014 11:25:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Clark Williams <clark.williams@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: unify boost and kthread priorities
Message-ID: <20140917182540.GG4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140915100524.2cd80d2e@sluggy>
 <20140916204156.GP4723@linux.vnet.ibm.com>
 <1410972543.31130.87.camel@x220>
 <20140917171717.GC4723@linux.vnet.ibm.com>
 <1410975957.31130.93.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410975957.31130.93.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091718-9332-0000-0000-0000020C9070
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 07:45:57PM +0200, Paul Bolle wrote:
> On Wed, 2014-09-17 at 10:17 -0700, Paul E. McKenney wrote:
> > On Wed, Sep 17, 2014 at 06:49:03PM +0200, Paul Bolle wrote:
> > > There's a reference to CONFIG_RCU_BOOST_PRIO in
> > > tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt. It needs
> > > updating too, doesn't it?
> > 
> > Good catch!
> > 
> > Also the one in tools/testing/selftests/rcutorture/configs/rcu/TREE03.
> 
> >From my local perl monstrosity:
> 	# ...  and Paul McKenney's rcutorture stuff (v3.14-rc+)
> 	if ($blob->[1] =~ /tools\/testing\/selftests\/rcutorture\/configs\/.*/) {
> 
> Ie, I've made that script ignore all references to Kconfig macros below
> tools/testing/selftest/rcutorture/configs. Is that too crude?

It would not hurt to check the files that appear in the CFLIST files:

	tools/testing/selftests/rcutorture/configs/lock/CFLIST
	tools/testing/selftests/rcutorture/configs/rcu/CFLIST

These files drive the torture-test kernel configurations.

That said, yes, there are sometimes some obsolete or deprecated
Kconfig parameters in these files because some systems need them.

							Thanx, Paul

> > Fixed both, thank you!
> 
> 
> Paul Bolle
> 

