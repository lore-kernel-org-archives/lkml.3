Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaGWMcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:32:05 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46484 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaGWMcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:32:02 -0400
Date: Wed, 23 Jul 2014 05:31:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:RCUTORTURE TEST F..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/16] rcu: kvm.sh: Fix error when you pass --cpus
 argument
Message-ID: <20140723123155.GO11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-17-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406092194-13004-17-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072312-9332-0000-0000-000001798DAE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 01:09:53AM -0400, Pranith Kumar wrote:
> When you pass --cpus argument to kvm.sh, it errors out as it assumes you have
> all the requires CPUs to run a batch. This commit fixes this along with a minor
> comment fix.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

The current code does what I want, namely allowing you to run tests
in parallel.  If you are running on a system with less than 16 CPUs,
this will of course not work -- and I -want- it to yell at me if I try
a full parallel run on my laptop instead of my lab machine.  One easy
way to work around this is to use the --configs argument to run the big
tests sequentially, then again to run the smaller tests in parallel.
So sorry, but no.

							Thanx, Paul

> ---
>  tools/testing/selftests/rcutorture/bin/kvm.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
> index 36534f9..1128d85 100755
> --- a/tools/testing/selftests/rcutorture/bin/kvm.sh
> +++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
> @@ -214,7 +214,7 @@ END {
>  	batch = 0;
>  	nc = -1;
> 
> -	# Each pass through the following loop creates on test batch
> +	# Each pass through the following loop creates one test batch
>  	# that can be executed concurrently given ncpus.  Note that a
>  	# given test that requires more than the available CPUs will run in
>  	# their own batch.  Such tests just have to make do with what
> @@ -228,7 +228,7 @@ END {
>  		for (i = 0; i < njobs; i++) {
>  			if (done[i])
>  				continue; # Already part of a batch.
> -			if (nc >= cpus[i] || nc == ncpus) {
> +			if (nc >= cpus[i]) {
> 
>  				# This test fits into the current batch.
>  				done[i] = batch;
> -- 
> 2.0.0.rc2
> 

