Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbaHaAcX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 20:32:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaHaAcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 20:32:21 -0400
Date: Sat, 30 Aug 2014 17:32:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ramon Fried <ramon.fried@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Daniel Borkmann <dborkman@redhat.com>, Alan Cox <alan@linux.intel.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        Mostyn Bramley-Moore <mbmcode@gmail.com>,
        Toby Smith <toby@tismith.id.au>,
        Archana kumari <archanakumari959@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Iulia Manda <iulia.manda21@gmail.com>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: netlogic: fixed checkpatch.pl styling warnings
Message-ID: <20140831003220.GA24828@kroah.com>
References: <1409444211-758-1-git-send-email-ramon.fried@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409444211-758-1-git-send-email-ramon.fried@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 03:16:48AM +0300, Ramon Fried wrote:
> This patch fixes the following checkpatch.pl warnings:
> 
> WARNING: Possible unnecessary 'out of memory' message
> #146: FILE: ./xlr_net.c:146:
> +       if (!skb) {
> +               pr_err("SKB allocation failed\n");
> 
> WARNING: Missing a blank line after declarations
> #1107: FILE: ./xlr_net.c:1107:
> +       struct xlr_net_priv *priv = platform_get_drvdata(pdev);
> +       unregister_netdev(priv->ndev);
> 
> Signed-off-by: Ramon Fried <ramon.fried@gmail.com>

This is two different things, and as such, should be sent in 2 different
patches?

Also, you sent this to a lot of people, did they all really need it?

> ---
>  drivers/staging/netlogic/xlr_net.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
> index 9bf407d..28a42831 100644
> --- a/drivers/staging/netlogic/xlr_net.c
> +++ b/drivers/staging/netlogic/xlr_net.c
> @@ -142,10 +142,8 @@ static inline struct sk_buff *xlr_alloc_skb(void)
>  
>  	/* skb->data is cache aligned */
>  	skb = alloc_skb(XLR_RX_BUF_SIZE, GFP_ATOMIC);
> -	if (!skb) {
> -		pr_err("SKB allocation failed\n");
> +	if (!skb)
>  		return NULL;
> -	}
>  	mac_put_skb_back_ptr(skb);
>  	return skb;
>  }
> @@ -1104,6 +1102,7 @@ err_gmac:
>  static int xlr_net_remove(struct platform_device *pdev)
>  {
>  	struct xlr_net_priv *priv = platform_get_drvdata(pdev);
> +
>  	unregister_netdev(priv->ndev);
>  	mdiobus_unregister(priv->mii_bus);
>  	mdiobus_free(priv->mii_bus);

Finally, this patch doesn't apply at all to my tree, so even if I wanted
to apply it, I couldn't.  Please refresh it against the staging-next
branch of the staging.git tree on git.kernel.org, and if it is still
relevant (hint, half of it isn't), then redo it and resend.

thanks,

greg k-h
