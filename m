Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161272AbaDPVON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:14:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42358 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552AbaDPVOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:14:11 -0400
Date: Wed, 16 Apr 2014 14:14:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel/rcu/rcutorture.c: use macro to define module
 parameter
Message-ID: <20140416211407.GA4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <534EEC6B.8030500@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534EEC6B.8030500@gatech.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041621-1542-0000-0000-00000123B19D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 04:47:39PM -0400, Pranith Kumar wrote:
> use the defined macro for module parameter definition
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

This fails for me.  The problem is that the defined macro makes everything
static, and rcutorture_runnable is used in kernel/sysctl.c.  :-/

In theory, it would be possible to make torture_param() take "static"
as a parameter, but this adds more characters than it removes.

							Thanx, Paul

> ---
>  kernel/rcu/rcutorture.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> index bd30bc6..1a0298c 100644
> --- a/kernel/rcu/rcutorture.c
> +++ b/kernel/rcu/rcutorture.c
> @@ -143,9 +143,8 @@ static struct list_head rcu_torture_removed;
>  #else
>  #define RCUTORTURE_RUNNABLE_INIT 0
>  #endif
> -int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
> -module_param(rcutorture_runnable, int, 0444);
> -MODULE_PARM_DESC(rcutorture_runnable, "Start rcutorture at boot");
> +torture_param(int, rcutorture_runnable, RCUTORTURE_RUNNABLE_INIT,
> +		"Start rcutorture at boot");
> 
>  #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU)
>  #define rcu_can_boost() 1
> -- 
> 1.7.9.5
> 

