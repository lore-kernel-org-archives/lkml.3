Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaHVVKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:10:42 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:33312 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaHVVKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:10:40 -0400
Message-ID: <1408741838.24496.15.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] tcm_fc: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: agrover@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Date: Fri, 22 Aug 2014 14:10:38 -0700
In-Reply-To: <20140818120537.GA19578@ada>
References: <20140818120537.GA19578@ada>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreea-Cristina,

On Mon, 2014-08-18 at 15:05 +0300, Andreea-Cristina Bernat wrote:
> The use of "rcu_assign_pointer()" is NULLing out the pointer.
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
>  drivers/target/tcm_fc/tfc_sess.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
> index 21ce508..ccee7e3 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c
> @@ -98,7 +98,7 @@ static void ft_tport_delete(struct ft_tport *tport)
>  	ft_sess_delete_all(tport);
>  	lport = tport->lport;
>  	BUG_ON(tport != lport->prov[FC_TYPE_FCP]);
> -	rcu_assign_pointer(lport->prov[FC_TYPE_FCP], NULL);
> +	RCU_INIT_POINTER(lport->prov[FC_TYPE_FCP], NULL);
>  
>  	tpg = tport->tpg;
>  	if (tpg) {

Applied to target-pending.git.

Thanks!

--nab

