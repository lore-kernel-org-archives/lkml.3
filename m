Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaLGUos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:44:48 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54747 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaLGUop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:44:45 -0500
Date: Sun, 7 Dec 2014 12:44:42 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/20] hp100: fix misspelling of current function in
 string
Message-ID: <20141207204442.GB5360@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
 <1417980062-25151-13-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417980062-25151-13-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia,

On Sun, Dec 07, 2014 at 08:20:54PM +0100, Julia Lawall wrote:
> Replace a misspelled function name by %s and then __func__.
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
>  drivers/net/ethernet/hp/hp100.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hp/hp100.c b/drivers/net/ethernet/hp/hp100.c
> index 76a6e0c..ae6e30d 100644
> --- a/drivers/net/ethernet/hp/hp100.c
> +++ b/drivers/net/ethernet/hp/hp100.c
> @@ -490,7 +490,8 @@ static int hp100_probe1(struct net_device *dev, int ioaddr, u_char bus,
>  
>  	eid = hp100_read_id(ioaddr);
>  	if (eid == NULL) {	/* bad checksum? */
> -		printk(KERN_WARNING "hp100_probe: bad ID checksum at base port 0x%x\n", ioaddr);
> +		printk(KERN_WARNING "%s: bad ID checksum at base port 0x%x\n",
> +		       __func__, ioaddr);
More printk statements that can be change to pr_warn() to fix the
checkpatch warning.

>  		goto out2;
>  	}
>  
> @@ -498,7 +499,9 @@ static int hp100_probe1(struct net_device *dev, int ioaddr, u_char bus,
>  	for (i = uc = 0; i < 7; i++)
>  		uc += hp100_inb(LAN_ADDR + i);
>  	if (uc != 0xff) {
> -		printk(KERN_WARNING "hp100_probe: bad lan address checksum at port 0x%x)\n", ioaddr);
> +		printk(KERN_WARNING
> +		       "%s: bad lan address checksum at port 0x%x)\n",
> +		       __func__, ioaddr);
And here too.

>  		err = -EIO;
>  		goto out2;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
