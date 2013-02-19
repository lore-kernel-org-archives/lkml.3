Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab3BSLfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:35:20 -0500
Received: from smtp-out-114.synserver.de ([212.40.185.114]:1115 "EHLO
	smtp-out-114.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3BSLfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:35:19 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24883
Message-ID: <512363CC.7000401@metafoo.de>
Date: Tue, 19 Feb 2013 12:36:44 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: maxin.john@gmail.com
CC: djbw@fb.com, vinod.koul@intel.com, geert@linux-m68k.org,
        linux-kernel@vger.kernel.org, "Maxin B. John" <maxin.john@enea.com>
Subject: Re: [PATCH] dma: timb_dma: Fix compiler warning
References: <1361217546-3116-1-git-send-email-maxin.john@gmail.com>
In-Reply-To: <1361217546-3116-1-git-send-email-maxin.john@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 08:59 PM, maxin.john@gmail.com wrote:
> From: "Maxin B. John" <maxin.john@enea.com>
> 
> Fix this compiler warning:
> warning: 'td_remove' defined but not used [-Wunused-function]
>
> Signed-off-by: Maxin B. John <maxin.john@enea.com>
> ---
>  drivers/dma/timb_dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
> index 952f823..f709279 100644
> --- a/drivers/dma/timb_dma.c
> +++ b/drivers/dma/timb_dma.c
> @@ -798,7 +798,7 @@ err_release_region:
>  
>  }
>  
> -static int td_remove(struct platform_device *pdev)
> +static int __exit td_remove(struct platform_device *pdev)
>  {

>

While this fixes the warning, it's the wrong fix. The correct fix is to
remove the __exit_p. E.g. something like this:

--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -823,7 +823,7 @@ static struct platform_driver td_driver = {
 		.owner  = THIS_MODULE,
 	},
 	.probe	= td_probe,
-	.remove	= __exit_p(td_remove),
+	.remove	= td_remove,
 };

 module_platform_driver(td_driver);
