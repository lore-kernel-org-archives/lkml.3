Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaGIKuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:50:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:17662 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGIKuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:50:06 -0400
X-IronPort-AV: E=Sophos;i="5.01,630,1400025600"; 
   d="scan'208";a="151185658"
Date: Wed, 9 Jul 2014 11:49:19 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Himangi Saraogi <himangi774@gmail.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        <xen-devel@lists.xenproject.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <julia.lawall@lip6.fr>, David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH] xen/arm: use BUG_ON
In-Reply-To: <20140708222634.GA11976@himangi-Dell>
Message-ID: <alpine.DEB.2.02.1407091148530.27641@kaball.uk.xensource.com>
References: <20140708222634.GA11976@himangi-Dell>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2014, Himangi Saraogi wrote:
> Use BUG_ON(x) rather than if(x) BUG();
> 
> The semantic patch that fixes this problem is as follows:
> 
> // <smpl>
> @@ identifier x; @@
> -if (x) BUG();
> +BUG_ON(x);
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/arm/xen/enlighten.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 1e63243..98544c5 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -181,8 +181,7 @@ static void xen_restart(enum reboot_mode reboot_mode, const char *cmd)
>  	struct sched_shutdown r = { .reason = SHUTDOWN_reboot };
>  	int rc;
>  	rc = HYPERVISOR_sched_op(SCHEDOP_shutdown, &r);
> -	if (rc)
> -		BUG();
> +	BUG_ON(rc);
>  }
>  
>  static void xen_power_off(void)
> @@ -190,8 +189,7 @@ static void xen_power_off(void)
>  	struct sched_shutdown r = { .reason = SHUTDOWN_poweroff };
>  	int rc;
>  	rc = HYPERVISOR_sched_op(SCHEDOP_shutdown, &r);
> -	if (rc)
> -		BUG();
> +	BUG_ON(rc);
>  }
>  
>  static int xen_cpu_notification(struct notifier_block *self,
> -- 
> 1.9.1
> 
