Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab3FYMLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:11:24 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26926 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3FYMLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:11:23 -0400
Message-ID: <51C987CE.50906@huawei.com>
Date: Tue, 25 Jun 2013 20:06:38 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Yijing Wang <wangyijing@huawei.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 9/9] radeon: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)
References: <1371543891-11460-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1371543891-11460-1-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping....?

On 2013/6/18 16:24, Yijing Wang wrote:
> Pci core has been saved pm cap register offset by pdev->pm_cap in pci_pm_init()
> in init path. So we can use pdev->pm_cap instead of using
> pci_find_capability(pdev, PCI_CAP_ID_PM) for better performance and simplified code.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-fbdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/video/aty/radeon_pm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_pm.c
> index 92bda58..f7091ec 100644
> --- a/drivers/video/aty/radeon_pm.c
> +++ b/drivers/video/aty/radeon_pm.c
> @@ -2805,7 +2805,7 @@ static void radeonfb_early_resume(void *data)
>  void radeonfb_pm_init(struct radeonfb_info *rinfo, int dynclk, int ignore_devlist, int force_sleep)
>  {
>  	/* Find PM registers in config space if any*/
> -	rinfo->pm_reg = pci_find_capability(rinfo->pdev, PCI_CAP_ID_PM);
> +	rinfo->pm_reg = rinfo->pdev->pm_cap;
>  
>  	/* Enable/Disable dynamic clocks: TODO add sysfs access */
>  	if (rinfo->family == CHIP_FAMILY_RS480)
> 


-- 
Thanks!
Yijing

