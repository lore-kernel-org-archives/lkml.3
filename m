Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaIYWBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:01:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:38909 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbaIYWBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:01:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,599,1406617200"; 
   d="scan'208";a="579147005"
Subject: Re: [PATCH] libfs: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
From: Vasu Dev <vasu.dev@linux.intel.com>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: robert.w.love@intel.com, JBottomley@parallels.com,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
In-Reply-To: <20140818145622.GA14281@ada>
References: <20140818145622.GA14281@ada>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Sep 2014 15:01:11 -0700
Message-ID: <1411682471.2856.3.camel@vfc0>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-18 at 17:56 +0300, Andreea-Cristina Bernat wrote:
> The uses of "rcu_assign_pointer()" are NULLing out the pointers.
> According to RCU_INIT_POINTER()'s block comment:
> "1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
> it is better to use it instead of rcu_assign_pointer() because it has a
> smaller overhead.
> 
> The following Coccinelle semantic patch was used:
> @@
> @@
> 
> - rcu_assign_pointer
> + RCU_INIT_POINTER
>   (..., NULL)
> 
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
> ---
>  drivers/scsi/libfc/fc_libfc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_libfc.c b/drivers/scsi/libfc/fc_libfc.c
> index 8d65a51a..c11a638 100644
> --- a/drivers/scsi/libfc/fc_libfc.c
> +++ b/drivers/scsi/libfc/fc_libfc.c
> @@ -296,9 +296,9 @@ void fc_fc4_deregister_provider(enum fc_fh_type type, struct fc4_prov *prov)
>  	BUG_ON(type >= FC_FC4_PROV_SIZE);
>  	mutex_lock(&fc_prov_mutex);
>  	if (prov->recv)
> -		rcu_assign_pointer(fc_passive_prov[type], NULL);
> +		RCU_INIT_POINTER(fc_passive_prov[type], NULL);
>  	else
> -		rcu_assign_pointer(fc_active_prov[type], NULL);
> +		RCU_INIT_POINTER(fc_active_prov[type], NULL);
>  	mutex_unlock(&fc_prov_mutex);
>  	synchronize_rcu();
>  }

Looks like patch is not yet applied.

Acked-by: Vasu Dev <vasu.dev@intel.com>


