Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaEHABf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 20:01:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43573 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaEHABa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 20:01:30 -0400
Date: Wed, 7 May 2014 17:01:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 15/45] torture: Make config-fragment
 filtering RCU-independent
Message-ID: <20140508000122.GV8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507212937.GI27924@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507212937.GI27924@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050800-6688-0000-0000-000001A73236
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:29:37PM -0700, josh@joshtriplett.org wrote:
> On Mon, Apr 28, 2014 at 05:25:03PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The torture tests need to set specific values for their respective
> > Kconfig options (e.g., CONFIG_LOCK_TORTURE_TEST), and must therefore
> > filter any conflicting definitions from the Kconfig fragment
> > file.  Unfortunately, the code in kvm-build.sh was looking only for
> > CONFIG_RCU_TORTURE_TEST.  This commit therefore handles the general case
> > of CONFIG_[A-Z]*TORTURE_TEST.
> 
> This doesn't match your code below, which includes an _ after the * .
> 
> Also, one nit below.
> 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> With the commit message fixed:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > ---
> >  tools/testing/selftests/rcutorture/bin/kvm-build.sh | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
> > index e838c775f709..6d0b76d918f4 100755
> > --- a/tools/testing/selftests/rcutorture/bin/kvm-build.sh
> > +++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
> > @@ -45,7 +45,7 @@ T=/tmp/test-linux.sh.$$
> >  trap 'rm -rf $T' 0
> >  mkdir $T
> >  
> > -cat ${config_template} | grep -v CONFIG_RCU_TORTURE_TEST > $T/config
> > +cat ${config_template} | grep -v 'CONFIG_[A-Z]*_TORTURE_TEST' > $T/config
> 
> UUOC (useless use of cat): you can redirect from ${config_template}
> rather than catting it.

Both good points!  Back when I was first using UNIX, that extra "cat"
would have cost me something like three seconds.  How quickly we forget!  ;-)

							Thanx, Paul

> >  cat << ___EOF___ >> $T/config
> >  CONFIG_INITRAMFS_SOURCE="$TORTURE_INITRD"
> >  CONFIG_VIRTIO_PCI=y
> > -- 
> > 1.8.1.5
> > 
> 

