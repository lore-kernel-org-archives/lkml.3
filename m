Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab3EBNqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:46:44 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32790 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155Ab3EBNqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:46:43 -0400
Date: Thu, 2 May 2013 08:43:45 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: mail@srajiv.net, tpmdd@selhorst.net, tpmdd@sirrix.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] tpm_tis: fix missing platform_driver_unregister
Message-ID: <20130502134345.GA28020@ennui.austin.ibm.com>
References: <51825086.3010205@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51825086.3010205@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050213-7182-0000-0000-0000068207D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 07:39:50PM +0800, Libo Chen wrote:
> 
> Add missing unregister tis_drv after register pdev fail
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

  Hi Libo - thanks for the contribution, but I got an similar patch
last week from Wei Yongjun. Its staged over here [1] and will be pushed
soon.

Thanks,
Kent

[1] git://github.com/shpedoikal/linux.git tpmdd-04-26-13

> ---
>  drivers/char/tpm/tpm_tis.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 8a41b6b..d5b0af4 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -884,8 +884,11 @@ static int __init init_tis(void)
>  	rc = platform_driver_register(&tis_drv);
>  	if (rc < 0)
>  		return rc;
> -	if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
> -		return PTR_ERR(pdev);
> +	pdev = platform_device_register_simple("tpm_tis", -1, NULL, 0);
> +	if (IS_ERR(pdev) {
> +	    platform_driver_unregister(&tis_drv);
> +	    return PTR_ERR(pdev);
> +	}
>  	if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
>  		platform_device_unregister(pdev);
>  		platform_driver_unregister(&tis_drv);
> -- 
> 1.7.1
> 

