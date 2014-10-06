Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaJFVOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:14:51 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48631 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaJFVOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:14:49 -0400
Date: Mon, 6 Oct 2014 22:14:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: core: Fix possible ZERO_SIZE_PTR pointer
 dereferencing error.
Message-ID: <20141006211443.GE18035@lee--X1>
References: <1411028499-44474-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411028499-44474-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Xiubo Li wrote:

> Since we cannot make sure the 'cell->num_resources' will always be none
> zero here, and then if either equal to zero, the kzalloc() will return
> ZERO_SIZE_PTR, which equals to ((void *)16).
> 
> So this patch fix this with just doing the zero check before calling
> kzalloc().
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  drivers/mfd/mfd-core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 892d343..54c7e35 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -89,6 +89,9 @@ static int mfd_add_device(struct device *parent, int id,
>  	int ret = -ENOMEM;
>  	int r;
>  
> +	if (!cell->num_resources)
> +		return -EINVAL;

Resources are not compulsory.

>  	pdev = platform_device_alloc(cell->name, id + cell->id);
>  	if (!pdev)
>  		goto fail_alloc;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
