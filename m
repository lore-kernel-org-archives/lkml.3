Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3FYMLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:11:00 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:22505 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3FYMK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:10:58 -0400
Message-ID: <51C987AA.9070006@huawei.com>
Date: Tue, 25 Jun 2013 20:06:02 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Yijing Wang <wangyijing@huawei.com>, Paul Mackerras <paulus@samba.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 3/9] aty128fb: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)
References: <1371543307-14360-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1371543307-14360-1-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.....?

On 2013/6/18 16:15, Yijing Wang wrote:
> Pci core has been saved pm cap register offset by pdev->pm_cap in pci_pm_init()
> in init path. So we can use pdev->pm_cap instead of using
> pci_find_capability(pdev, PCI_CAP_ID_PM) for better performance and simplified code.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/aty/aty128fb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
> index 8c55011..a4dfe8c 100644
> --- a/drivers/video/aty/aty128fb.c
> +++ b/drivers/video/aty/aty128fb.c
> @@ -2016,7 +2016,7 @@ static int aty128_init(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	aty128_init_engine(par);
>  
> -	par->pm_reg = pci_find_capability(pdev, PCI_CAP_ID_PM);
> +	par->pm_reg = pdev->pm_cap;
>  	par->pdev = pdev;
>  	par->asleep = 0;
>  	par->lock_blank = 0;
> 


-- 
Thanks!
Yijing

