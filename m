Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaEGX7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:59:18 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49783 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaEGX7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:59:17 -0400
Date: Wed, 7 May 2014 16:59:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 12/45] torture: Rename RCU_QEMU_MAC to
 TORTURE_QEMU_MAC
Message-ID: <20140507235910.GT8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-12-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507212756.GH27924@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507212756.GH27924@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050723-0928-0000-0000-000001C7544F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:27:56PM -0700, josh@joshtriplett.org wrote:
> On Mon, Apr 28, 2014 at 05:25:00PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > This commit makes the torture scripts a bit more RCU-independent.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> One comment below; with or without that change:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > ---
> >  tools/testing/selftests/rcutorture/bin/functions.sh | 6 +++---
> >  tools/testing/selftests/rcutorture/bin/kvm.sh       | 4 ++--
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
> > index 623939cf814e..41fb52b805e4 100644
> > --- a/tools/testing/selftests/rcutorture/bin/functions.sh
> > +++ b/tools/testing/selftests/rcutorture/bin/functions.sh
> > @@ -124,7 +124,7 @@ identify_qemu_append () {
> >  
> >  # identify_qemu_args qemu-cmd serial-file
> >  #
> > -# Output arguments for qemu arguments based on the RCU_QEMU_MAC
> > +# Output arguments for qemu arguments based on the TORTURE_QEMU_MAC
> >  # and TORTURE_QEMU_INTERACTIVE environment variables.
> >  identify_qemu_args () {
> >  	case "$1" in
> > @@ -133,9 +133,9 @@ identify_qemu_args () {
> >  	qemu-system-ppc64)
> >  		echo -enable-kvm -M pseries -cpu POWER7 -nodefaults
> >  		echo -device spapr-vscsi
> > -		if test -n "$TORTURE_QEMU_INTERACTIVE" -a -n "$RCU_QEMU_MAC"
> > +		if test -n "$TORTURE_QEMU_INTERACTIVE" -a -n "$TORTURE_QEMU_MAC"
> >  		then
> > -			echo -device spapr-vlan,netdev=net0,mac=$RCU_QEMU_MAC
> > +			echo -device spapr-vlan,netdev=net0,mac=$TORTURE_QEMU_MAC
> >  			echo -netdev bridge,br=br0,id=net0
> >  		elif test -n "$TORTURE_QEMU_INTERACTIVE"
> >  		then
> > diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
> > index 2f9605ed5b58..1a4a68c76914 100644
> > --- a/tools/testing/selftests/rcutorture/bin/kvm.sh
> > +++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
> > @@ -128,7 +128,7 @@ do
> >  		;;
> >  	--mac)
> >  		checkarg --mac "(MAC address)" $# "$2" '^\([0-9a-fA-F]\{2\}:\)\{5\}[0-9a-fA-F]\{2\}$' error
> > -		RCU_QEMU_MAC=$2; export RCU_QEMU_MAC
> > +		TORTURE_QEMU_MAC=$2; export TORTURE_QEMU_MAC
> 
> Can't you drop this export the same way you did previous exports?

Good point, will do!

							Thanx, Paul

> >  		shift
> >  		;;
> >  	--no-initrd)
> > @@ -380,7 +380,7 @@ then
> >  	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
> >  	echo TORTURE_QEMU_INTERACTIVE="$TORTURE_QEMU_INTERACTIVE;
> >  		export TORTURE_QEMU_INTERACTIVE"
> > -	echo RCU_QEMU_MAC="$RCU_QEMU_MAC; export RCU_QEMU_MAC"
> > +	echo TORTURE_QEMU_MAC="$TORTURE_QEMU_MAC; export TORTURE_QEMU_MAC"
> >  	echo "mkdir -p "$resdir" || :"
> >  	echo "mkdir $resdir/$ds"
> >  	cat $T/script
> > -- 
> > 1.8.1.5
> > 
> 

