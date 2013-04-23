Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab3DWM4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:56:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41632 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab3DWM4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:56:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pnp: use %*phC to dump small buffers
Date: Tue, 23 Apr 2013 15:04:50 +0200
Message-ID: <2649130.8XKsilpdSa@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1366635665-11365-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1366635665-11365-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 22, 2013 04:01:05 PM Andy Shevchenko wrote:

Any changelog?

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/pnp/isapnp/core.c  | 5 +----
>  drivers/pnp/pnpbios/proc.c | 5 ++---
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
> index 918d5f0..f380bcf 100644
> --- a/drivers/pnp/isapnp/core.c
> +++ b/drivers/pnp/isapnp/core.c
> @@ -814,10 +814,7 @@ static int __init isapnp_build_device_list(void)
>  			continue;
>  
>  #if 0
> -		dev_info(&card->dev,
> -		       "vendor: %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
> -		       header[0], header[1], header[2], header[3], header[4],
> -		       header[5], header[6], header[7], header[8]);
> +		dev_info(&card->dev, "vendor: %9phC\n", header);
>  		dev_info(&card->dev, "checksum = %#x\n", checksum);
>  #endif

I'd rather see that #if 0 block go away entirely.

>  		INIT_LIST_HEAD(&card->devices);
> diff --git a/drivers/pnp/pnpbios/proc.c b/drivers/pnp/pnpbios/proc.c
> index 8dafd65..c212db0 100644
> --- a/drivers/pnp/pnpbios/proc.c
> +++ b/drivers/pnp/pnpbios/proc.c
> @@ -185,10 +185,9 @@ static int pnp_devices_proc_show(struct seq_file *m, void *v)
>  
>  		if (pnp_bios_get_dev_node(&nodenum, PNPMODE_DYNAMIC, node))
>  			break;
> -		seq_printf(m, "%02x\t%08x\t%02x:%02x:%02x\t%04x\n",
> +		seq_printf(m, "%02x\t%08x\t%3phC\t%04x\n",
>  			     node->handle, node->eisa_id,
> -			     node->type_code[0], node->type_code[1],
> -			     node->type_code[2], node->flags);
> +			     node->type_code, node->flags);
>  		if (nodenum <= thisnodenum) {
>  			printk(KERN_ERR
>  			       "%s Node number 0x%x is out of sequence following node 0x%x. Aborting.\n",
> 

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
