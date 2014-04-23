Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaDWFxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:53:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55708 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaDWFxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:53:15 -0400
Date: Tue, 22 Apr 2014 22:53:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] soc_button_array: fix a crash during rmmod
Message-ID: <20140423055312.GB24854@core.coreip.homeip.net>
References: <53560DD1.5050805@linux.intel.com>
 <53560E6F.9000806@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53560E6F.9000806@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 02:38:39PM +0800, Zhu, Lejun wrote:
> When the system has zero or one button available, trying to rmmod
> soc_button_array will cause crash. Fix this by properly handling -ENODEV
> in probe().
> 
> Signed-off-by: Lejun Zhu <lejun.zhu@linux.intel.com>

Applied, thank you.

> ---
>  drivers/input/misc/soc_button_array.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/input/misc/soc_button_array.c
> b/drivers/input/misc/soc_button_array.c
> index 08ead2a..20c80f5 100644
> --- a/drivers/input/misc/soc_button_array.c
> +++ b/drivers/input/misc/soc_button_array.c
> @@ -169,6 +169,7 @@ static int soc_button_pnp_probe(struct pnp_dev *pdev,
>  				soc_button_remove(pdev);
>  				return error;
>  			}
> +			continue;
>  		}
> 
>  		priv->children[i] = pd;
> -- 
> 1.8.3.2
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 

-- 
Dmitry
