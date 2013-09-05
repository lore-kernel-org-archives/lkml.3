Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221Ab3IEKsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:48:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21666 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3IEKsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:48:36 -0400
Date: Thu, 5 Sep 2013 13:48:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wei_wang@realsil.com.cn
Cc: sameo@linux.intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, rogerable@realtek.com,
        devel@linuxdriverproject.org
Subject: Re: [PATCH] mfd: rtsx: Modify rts5249_optimize_phy
Message-ID: <20130905104820.GL6329@mwanda>
References: <1378374338-11455-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378374338-11455-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 05:45:38PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> In some platforms, specially Thinkpad series, rts5249 won't be
> initialized properly. So we need adjust some phy parameters to
> improve the compatibility issue.
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mfd/rts5249.c |   25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
> index 3b835f5..e3c6dc1 100644
> --- a/drivers/mfd/rts5249.c
> +++ b/drivers/mfd/rts5249.c
> @@ -130,13 +130,34 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
>  {
>  	int err;
>  
> -	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV, 0xFE46);
> +	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV, 0xFC6C);


How are we supposed to review this change?  What happened to 0xFE46?
What are all these magic numbers?  I understand that this fixes an issue
for think pads but does it break something else?

regards,
dan carpenter

