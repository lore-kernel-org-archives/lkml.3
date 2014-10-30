Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbaJ3OUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:20:14 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51715 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996AbaJ3OUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:20:12 -0400
X-Originating-IP: 50.43.41.112
Date: Thu, 30 Oct 2014 07:19:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu 1/6] torture: Run Linux-kernel binary out of
 results directory
Message-ID: <20141030141956.GG32353@thin>
References: <20141028222929.GA29476@linux.vnet.ibm.com>
 <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:30:00PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The rcutorture scripts create a qemu-cmd script containing the actual
> qemu command.  However, this command references the build directory,
> which will be overwritten by later builds.  This commit therefore runs
> the kernel out of the results directory so that less hand-editing is
> required to re-run a previous test.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
> index f6b2b4771b78..e0f896999d6b 100755
> --- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
> +++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
> @@ -168,8 +168,8 @@ then
>  	touch $resdir/buildonly
>  	exit 0
>  fi
> -echo $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
> -( $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval ) &
> +echo $QEMU $qemu_args -m 512 -kernel $resdir/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
> +( $QEMU $qemu_args -m 512 -kernel $resdir/bzImage -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval ) &
>  qemu_pid=$!
>  commandcompleted=0
>  echo Monitoring qemu job at pid $qemu_pid
> -- 
> 1.8.1.5
> 
