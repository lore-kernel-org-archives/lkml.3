Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaBISQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:16:00 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55441 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaBISP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:15:58 -0500
Date: Sun, 9 Feb 2014 10:15:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: disambiguate CONFIG_RCU_NOCB_CPUs
Message-ID: <20140209181550.GD4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1391952911.25424.7.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391952911.25424.7.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020918-1344-0000-0000-00000590D7DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 02:35:11PM +0100, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  kernel/rcu/tree_plugin.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 6e2ef4b..366e21e 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2893,7 +2893,7 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
>   * CPU unless the grace period has extended for too long.
>   *
>   * This code relies on the fact that all NO_HZ_FULL CPUs are also
> - * CONFIG_RCU_NOCB_CPUs.
> + * CONFIG_RCU_NOCB_CPU CPUs.
>   */
>  static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
>  {

Applied as follows, good catch!

							Thanx, Paul

------------------------------------------------------------------------


rcu: Disambiguate CONFIG_RCU_NOCB_CPUs

This commit fixes a grammar issue in the rcu_nohz_full_cpu() comment
header, so that it is clear that the plural is CPUs not Kconfig options.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index bdc2e56b3e06..962d1d589929 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2902,7 +2902,7 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
  * CPU unless the grace period has extended for too long.
  *
  * This code relies on the fact that all NO_HZ_FULL CPUs are also
- * CONFIG_RCU_NOCB_CPUs.
+ * CONFIG_RCU_NOCB_CPU CPUs.
  */
 static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
 {

