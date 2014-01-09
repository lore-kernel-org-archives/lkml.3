Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaAIEcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:32:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaAIEcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:32:50 -0500
Date: Wed, 8 Jan 2014 20:33:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Wang YanQing <udknight@gmail.com>, jslaby@suse.cz, airlied@redhat.com,
        akpm@linux-foundation.org, kilobyte@angband.pl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: initialize con_driver->node in con_init
Message-ID: <20140109043313.GA28887@kroah.com>
References: <20131230031102.GA4424@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230031102.GA4424@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 11:11:02AM +0800, Wang YanQing wrote:
> Commit 6db4063c5b72b46e9793b0f141a7a3984ac6facf
> ("[PATCH] VT binding: Add sysfs control to the VT layer")
> add node item into struct con_driver.

That patch was from 2006.  Why is this change needed now, what problems
happen without your fix below?

thanks,

greg k-h

> 
> This patch initialize con_driver->node in con_init.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  drivers/tty/vt/vt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index edcd6b8..9adb4e0 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -2879,6 +2879,7 @@ static int __init con_init(void)
>  		if (con_driver->con == NULL) {
>  			con_driver->con = conswitchp;
>  			con_driver->desc = display_desc;
> +			con_driver->node = i;
>  			con_driver->flag = CON_DRIVER_FLAG_INIT;
>  			con_driver->first = 0;
>  			con_driver->last = MAX_NR_CONSOLES - 1;
> -- 
> 1.8.3.4.8.g69490f3.dirty
