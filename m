Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaDYWbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:31:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaDYWbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:31:04 -0400
Date: Fri, 25 Apr 2014 15:33:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tulinizer@gmail.com, viro@zeniv.linux.org.uk, lorenz@badgers.com
Subject: Re: [PATCH] staging: silicom: Add appropriate ifdef conditions in
 bpctl_mod.c
Message-ID: <20140425223356.GA7045@kroah.com>
References: <5315479.ef9aFRk9hG@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5315479.ef9aFRk9hG@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 12:03:41PM +0900, Daeseok Youn wrote:
> 
> The bp_proc_create() can be called if BP_PROC_SUPPORT is defined.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/silicom/bpctl_mod.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
> index 6b9365b..5a3d758 100644
> --- a/drivers/staging/silicom/bpctl_mod.c
> +++ b/drivers/staging/silicom/bpctl_mod.c
> @@ -119,7 +119,10 @@ static void if_scan_init(void);
>  
>  static int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block);
>  static int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block);
> +
> +#ifdef BP_PROC_SUPPORT
>  static int bp_proc_create(void);
> +#endif

No, this code should just be removed, right?

