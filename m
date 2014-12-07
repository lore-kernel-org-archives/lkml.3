Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaLGUlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:41:45 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57421 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaLGUll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:41:41 -0500
Date: Sun, 7 Dec 2014 12:41:38 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/20] USB: isp1760: fix misspelling of current function
 in string
Message-ID: <20141207204138.GA5360@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
 <1417980062-25151-9-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417980062-25151-9-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia,

On Sun, Dec 07, 2014 at 08:20:50PM +0100, Julia Lawall wrote:
> Replace a misspelled function name by %s and then __func__.
> 
> The function name starts with isp, not ips.
> 
> This was done using Coccinelle, including the use of Levenshtein distance,
> as proposed by Rasmus Villemoes.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> The semantic patch is difficult to summarize, but is available in the cover
> letter of this patch series.
> 
>  drivers/usb/host/isp1760-if.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
> index 09254a4..939d376 100644
> --- a/drivers/usb/host/isp1760-if.c
> +++ b/drivers/usb/host/isp1760-if.c
> @@ -318,7 +318,7 @@ static void isp1761_pci_remove(struct pci_dev *dev)
>  
>  static void isp1761_pci_shutdown(struct pci_dev *dev)
>  {
> -	printk(KERN_ERR "ips1761_pci_shutdown\n");
> +	printk(KERN_ERR "%s\n", __func__);
>  }
>  
You can also switch from printk to pr_err and that would fix thte
checkpatch warning for this patch.

>  static const struct pci_device_id isp1760_plx [] = {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
- Jeremiah Mahler
