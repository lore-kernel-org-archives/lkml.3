Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaB1RES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:04:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaB1RER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:04:17 -0500
Date: Fri, 28 Feb 2014 09:05:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Surendra Patil <surendra.tux@gmail.com>
Cc: rupesh.gujare@atmel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:staging:ozwpan Fixed sparse context imbalance
 warning
Message-ID: <20140228170555.GA20856@kroah.com>
References: <1393606622-7549-1-git-send-email-surendra.tux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393606622-7549-1-git-send-email-surendra.tux@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 08:57:02AM -0800, Surendra Patil wrote:
> Sparse warns about -
> drivers/staging/ozwpan/ozproto.c:797:6: warning: context imbalance in 'oz_polling_lock_bh' - wrong count at exit
> drivers/staging/ozwpan/ozproto.c:802:6: warning: context imbalance in 'oz_polling_unlock_bh' - unexpected unlock
> so added __acquires() and __releases().
> 
> Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
> ---
>  drivers/staging/ozwpan/ozproto.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
> index e7138ed..b47cec1 100644
> --- a/drivers/staging/ozwpan/ozproto.c
> +++ b/drivers/staging/ozwpan/ozproto.c
> @@ -795,11 +795,13 @@ int oz_get_pd_list(struct oz_mac_addr *addr, int max_count)
>  }
>  
>  void oz_polling_lock_bh(void)
> +__acquires(&g_polling_block)
>  {
>  	spin_lock_bh(&g_polling_lock);
>  }
>  
>  void oz_polling_unlock_bh(void)
> +__releases(&g_polling_block)
>  {
>  	spin_unlock_bh(&g_polling_lock);
>  }

How about ripping out this "wrapper" function entirely and replacing all
calls to them with the "real" call to the spinlock function?

thanks,

greg k-h
