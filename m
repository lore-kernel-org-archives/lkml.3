Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaI1QYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:24:11 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:65451 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaI1QYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:24:10 -0400
Date: Sun, 28 Sep 2014 21:53:57 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Nicholas Krause <yocto6@gmail.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: Remove read of issue in sa1111.c in sa1111_resume
Message-ID: <20140928162357.GA2542@sudip-PC>
References: <1411872652-16207-1-git-send-email-yocto6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411872652-16207-1-git-send-email-yocto6@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 10:50:52PM -0400, Nicholas Krause wrote:
> This removes the FIXME message and issue with reading in this driver before resuming
> in the function, sa1111_resume.
> 
> Signed-off-by: Nicholas Krause <yocto6@gmail.com>
> ---
>  arch/arm/common/sa1111.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
> index e57d7e5..0c4b9a9 100644
> --- a/arch/arm/common/sa1111.c
> +++ b/arch/arm/common/sa1111.c
> @@ -950,9 +950,7 @@ static int sa1111_resume(struct platform_device *dev)
>  
>  	/*
>  	 * Ensure that the SA1111 is still here.
> -	 * FIXME: shouldn't do this here.
>  	 */
> -	id = sa1111_readl(sachip->base + SA1111_SKID);

do you understand the effect of removing this???
what is the value of id in the next part of the code?

thanks
sudip
>  	if ((id & SKID_ID_MASK) != SKID_SA1111_ID) {
>  		__sa1111_remove(sachip);
>  		platform_set_drvdata(dev, NULL);
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
