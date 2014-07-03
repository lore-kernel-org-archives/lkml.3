Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaGCLt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:49:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48800 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaGCLt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:49:27 -0400
Date: Thu, 3 Jul 2014 13:49:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpc925_edac: Use module_platform_driver()
Message-ID: <20140703114918.GC21776@pd.tnic>
References: <1402324818-12300-1-git-send-email-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1402324818-12300-1-git-send-email-wangkefeng.wang@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 10:40:18PM +0800, Kefeng Wang wrote:
> Move edac_op_state assignment operations to probe, then convert to
> module_platform_drive() to eliminate boilerplate code, and use
> cpc925_printk instead of printk.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  drivers/edac/cpc925_edac.c |   33 +++++++--------------------------
>  1 files changed, 7 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
> index df6575f..8e3192a 100644
> --- a/drivers/edac/cpc925_edac.c
> +++ b/drivers/edac/cpc925_edac.c
> @@ -944,6 +944,12 @@ static int cpc925_probe(struct platform_device *pdev)
>  
>  	edac_dbg(0, "%s platform device found!\n", pdev->name);
>  
> +	cpc925_printk(KERN_INFO, CPC925_EDAC_REVISION "\n");
> +	cpc925_printk(KERN_INFO, "\t(c) 2008 Wind River Systems, Inc\n");

This will issue multiple times on a multi-node machine with several such
bridges.

The bit converting to cpc925_printk is ok and I'll take it if you create
a patch only for it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
