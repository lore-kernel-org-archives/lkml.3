Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3JaOQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:16:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43481 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab3JaOQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:16:31 -0400
Date: Thu, 31 Oct 2013 08:16:19 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: rchinthekindi@stec-inc.com, abhansali@stec-inc.com, jmoyer@redhat.com,
        ramprasad.chinthekindi@hgst.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] skd: fix error return code in skd_pci_probe()
Message-ID: <20131031141619.GG10091@kernel.dk>
References: <CAPgLHd-HqMsv_CAbHUUaOw=3GSZbGXLmYvQVXJVAk5j0JYxdNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-HqMsv_CAbHUUaOw=3GSZbGXLmYvQVXJVAk5j0JYxdNQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30 2013, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENOMEM in the skd construct error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/block/skd_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
> index ab17bff..1a8717f 100644
> --- a/drivers/block/skd_main.c
> +++ b/drivers/block/skd_main.c
> @@ -5321,8 +5321,10 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	}
>  
>  	skdev = skd_construct(pdev);
> -	if (skdev == NULL)
> +	if (skdev == NULL) {
> +		rc = -ENOMEM;
>  		goto err_out_regions;
> +	}
>  
>  	skd_pci_info(skdev, pci_str);
>  	pr_info("(%s): %s 64bit\n", skd_name(skdev), pci_str);

Applied, thanks.

-- 
Jens Axboe

