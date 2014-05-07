Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaEGV3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:29:43 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46867 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaEGV3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:29:41 -0400
Date: Wed, 7 May 2014 14:29:37 -0700
From: josh@joshtriplett.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 15/45] torture: Make config-fragment
 filtering RCU-independent
Message-ID: <20140507212937.GI27924@cloud>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-15-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398731133-18925-15-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 05:25:03PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The torture tests need to set specific values for their respective
> Kconfig options (e.g., CONFIG_LOCK_TORTURE_TEST), and must therefore
> filter any conflicting definitions from the Kconfig fragment
> file.  Unfortunately, the code in kvm-build.sh was looking only for
> CONFIG_RCU_TORTURE_TEST.  This commit therefore handles the general case
> of CONFIG_[A-Z]*TORTURE_TEST.

This doesn't match your code below, which includes an _ after the * .

Also, one nit below.

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

With the commit message fixed:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  tools/testing/selftests/rcutorture/bin/kvm-build.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
> index e838c775f709..6d0b76d918f4 100755
> --- a/tools/testing/selftests/rcutorture/bin/kvm-build.sh
> +++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
> @@ -45,7 +45,7 @@ T=/tmp/test-linux.sh.$$
>  trap 'rm -rf $T' 0
>  mkdir $T
>  
> -cat ${config_template} | grep -v CONFIG_RCU_TORTURE_TEST > $T/config
> +cat ${config_template} | grep -v 'CONFIG_[A-Z]*_TORTURE_TEST' > $T/config

UUOC (useless use of cat): you can redirect from ${config_template}
rather than catting it.

>  cat << ___EOF___ >> $T/config
>  CONFIG_INITRAMFS_SOURCE="$TORTURE_INITRD"
>  CONFIG_VIRTIO_PCI=y
> -- 
> 1.8.1.5
> 
