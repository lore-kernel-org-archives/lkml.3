Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3FATnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:43:45 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56437 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab3FATnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:43:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: rafael.j.wysocki@intel.com, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pnpbios: Cocci spatch "ptr_ret.spatch"
Date: Sat, 01 Jun 2013 21:52:39 +0200
Message-ID: <3588723.7sXA8s0vDi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1370080441.29224.27.camel@localhost.localdomain>
References: <1370080441.29224.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 01, 2013 11:54:01 AM Thomas Meyer wrote:
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Changelog, please?

Rafael


> ---
> 
> diff -u -p a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
> --- a/drivers/pnp/pnpbios/core.c
> +++ b/drivers/pnp/pnpbios/core.c
> @@ -572,10 +572,7 @@ static int __init pnpbios_thread_init(vo
>  
>  	init_completion(&unload_sem);
>  	task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
> -	if (IS_ERR(task))
> -		return PTR_ERR(task);
> -
> -	return 0;
> +	return PTR_RET(task);
>  }
>  
>  /* Start the kernel thread later: */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
