Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaEOVyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:54:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaEOVyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:54:21 -0400
Date: Thu, 15 May 2014 14:57:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Denis Pithon <denis.pithon@gmail.com>
Cc: devel@driverdev.osuosl.org, himangi774@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] staging/wlan-ng: replace printk() with pr_xxx()
Message-ID: <20140515215739.GC4642@kroah.com>
References: <1399908167-19271-1-git-send-email-denis.pithon@gmail.com>
 <1399908167-19271-4-git-send-email-denis.pithon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399908167-19271-4-git-send-email-denis.pithon@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 05:22:47PM +0200, Denis Pithon wrote:
> Fix some coding style issues concerning printk() usage.
> 
> Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
> ---
>  drivers/staging/wlan-ng/p80211netdev.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
> index 61a3092..3577d20 100644
> --- a/drivers/staging/wlan-ng/p80211netdev.c
> +++ b/drivers/staging/wlan-ng/p80211netdev.c
> @@ -384,8 +384,9 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
>  		 */
>  		if (skb->protocol != ETH_P_80211_RAW) {
>  			netif_start_queue(wlandev->netdev);
> -			printk(KERN_NOTICE
> -			       "Tx attempt prior to association, frame dropped.\n");
> +			pr_notice(
> +			   "Tx attempt prior to association, frame dropped\n"
> +			);

Can't these be netdev messages, or at the least, dev_* messages?

thanks,

greg k-h
