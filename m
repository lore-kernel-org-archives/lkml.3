Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3GXWSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:18:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3GXWSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:18:50 -0400
Date: Wed, 24 Jul 2013 15:18:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dean Jenkins <Dean_Jenkins@mentor.com>
Cc: Andre Naujoks <nautsch2@gmail.com>, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 4/5] SLIP: Add error message for xleft non-zero
Message-ID: <20130724221849.GD21709@kroah.com>
References: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com>
 <1372779094-11730-5-git-send-email-Dean_Jenkins@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372779094-11730-5-git-send-email-Dean_Jenkins@mentor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 04:31:33PM +0100, Dean Jenkins wrote:
> Add a printk to show when xleft is non-zero in sl_encaps.
> 
> The idea is to see whether a previous SLIP frame failed to be
> fully transmitted.
> 
> Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
> ---
>  drivers/net/slip/slip.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index f7303e0..e2eff84 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -395,6 +395,10 @@ static void sl_encaps(struct slip *sl, unsigned char *icp, int len)
>  #endif
>  		count = slip_esc(p, sl->xbuff, len);
>  
> +	if (sl->xleft)
> +		printk(KERN_ERR "%s: ERROR: xleft is non-zero %d\n",
> +		       __func__, sl->xleft);

dev_err() perhaps?

thanks,

greg k-h
