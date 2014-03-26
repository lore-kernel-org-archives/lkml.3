Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbaCZV47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:56:59 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:34324 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaCZV45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:56:57 -0400
Message-ID: <1395871015.12610.254.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 2/7] atm: replace del_timer by del_timer_sync
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: "David S. Miller" <davem@davemloft.net>, kernel-janitors@vger.kernel.org,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Mar 2014 14:56:55 -0700
In-Reply-To: <1395869625-15209-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1395869625-15209-3-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-26 at 22:33 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>

> 
> diff --git a/net/atm/mpc.c b/net/atm/mpc.c
> index b71ff6b..91dc58f 100644
> --- a/net/atm/mpc.c
> +++ b/net/atm/mpc.c
> @@ -1492,7 +1492,7 @@ static void __exit atm_mpoa_cleanup(void)
>  
>  	mpc_proc_clean();
>  
> -	del_timer(&mpc_timer);
> +	del_timer_sync(&mpc_timer);
>  	unregister_netdevice_notifier(&mpoa_notifier);
>  	deregister_atm_ioctl(&atm_ioctl_ops);
>  

It seems this timer rearms itself, so this patch wont be enough I fear.




