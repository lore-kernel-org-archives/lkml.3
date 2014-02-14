Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaBNAcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:32:12 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52657 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaBNAcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:32:11 -0500
Date: Thu, 13 Feb 2014 16:32:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: fix sparse warning for rcu_expedited from
 kernel/ksysfs.c
Message-ID: <20140214003207.GN4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1392153012-14378-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392153012-14378-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021400-6688-0000-0000-0000067F9688
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:10:12PM -0500, Paul Gortmaker wrote:
> To fix:
> 
> kernel/ksysfs.c:143:5: warning: symbol 'rcu_expedited' was not declared. Should it be static?
> 
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Queued, thank you!

							Thanx, Paul

> ---
>  kernel/ksysfs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
> index d945a949760f..53476a147b9a 100644
> --- a/kernel/ksysfs.c
> +++ b/kernel/ksysfs.c
> @@ -19,6 +19,8 @@
>  #include <linux/sched.h>
>  #include <linux/capability.h>
> 
> +#include "rcu/rcu.h"	/* rcu_expedited */
> +
>  #define KERNEL_ATTR_RO(_name) \
>  static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
> 
> -- 
> 1.8.5.2
> 

