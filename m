Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaEHBy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 21:54:26 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37966 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaEHByY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 21:54:24 -0400
X-Originating-IP: 50.43.32.211
Date: Wed, 7 May 2014 18:54:08 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 07/45] torture: Allow variations of
 "defconfig" to be specified
Message-ID: <20140508015408.GA10988@thin>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507212219.GC27924@cloud>
 <20140507235240.GQ8754@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507235240.GQ8754@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 04:52:40PM -0700, Paul E. McKenney wrote:
> On Wed, May 07, 2014 at 02:22:19PM -0700, josh@joshtriplett.org wrote:
> > On Mon, Apr 28, 2014 at 05:24:55PM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > Some environments require some variation on "make defconfig" to initialize
> > > the .config file.  This commit therefore adds a --defconfig argument to
> > > allow this to be specified.  The default value is of course "defconfig".
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > <bikeshed color="blue">
> > "--defconfig randconfig" or "--defconfig allyesconfig" or similar seems
> > rather odd; how about calling it --kconfig or similar?
> > </bikeshed>
> 
> Some day I am going to have to feed that to a browser and see what
> happens.  ;-)
> 
> I must confess that I hadn't considered feeding randconfig or allyesconfig
> to that argument, partly because I figured that I would have to also
> supply Kconfig constraints in those cases in order to ensure that the
> resulting kernel would actually run under qemu.  I was instead thinking
> in terms of a --configs option beginning with "RAND", which would pick
> up the Kconfig constraints from the appropriate configs directory,
> for example:
> 
> 	tools/testing/selftests/rcutorture/configs/rcu/RAND1
> 
> That said, I haven't thought that far down that path.
> 
> So for the --defconfig argument, I was thinking more in terms of things
> like pseries_defconfig or versatile_defconfig.

Ah, I see.  --defconfig specifies the base configuration, while
--configs specifies the constraints.  In that case, how about
--baseconfig?  It might still make sense to pass --baseconfig
allnoconfig or --baseconfig allyesconfig or --baseconfig randconfig,
given a sufficiently complete constraints file.

- Josh Triplett
