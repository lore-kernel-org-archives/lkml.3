Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaHHCSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 22:18:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbaHHCSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 22:18:44 -0400
Date: Thu, 7 Aug 2014 19:18:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Martin Berglund <martin@rogsta.net>
Cc: Forest Bond <forest@alittletooquiet.net>,
        Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: wpactl.c: Fix sparse warnings
Message-ID: <20140808021813.GB22340@kroah.com>
References: <20140807220834.GA21645@licorice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807220834.GA21645@licorice>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 11:08:34PM +0100, Martin Berglund wrote:
> Add missing __user macro casting in the function wpa_set_keys.
> This is okay since the function handles the possibility of
> param->u.wpa_key.key and param->u.wpa_key.seq pointing to
> kernelspace using a flag, fcpfkernel.
> 
> Signed-off-by: Martin Berglund <martin@rogsta.net>
> ---
> This was submitted as part of Eudyptula challenge task 16
> 
>  drivers/staging/vt6655/wpactl.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
> index 5f454ca..d75dd79 100644
> --- a/drivers/staging/vt6655/wpactl.c
> +++ b/drivers/staging/vt6655/wpactl.c
> @@ -224,7 +224,9 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
>  	} else {
>  		spin_unlock_irq(&pDevice->lock);
>  		if (param->u.wpa_key.key &&
> -		    copy_from_user(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len)) {
> +		    copy_from_user(&abyKey[0],
> +				   (void __user *)param->u.wpa_key.key,

Would it be better to mark this pointer as __user in the structure
itself?  Or is it also used as a kernel structure in other places?

thanks,

greg k-h
