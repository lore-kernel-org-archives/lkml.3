Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab3E3STW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:19:22 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:44911 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3E3STP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:19:15 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Yijing Wang <wangyijing@huawei.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <liuj97@gmail.com>
Subject: RE: [PATCH 5/7] dwc2: remove redundant D0 power state set
Thread-Topic: [PATCH 5/7] dwc2: remove redundant D0 power state set
Thread-Index: AQHOXR/juT/gkoBISUSb910mM5GaiJkeCUDA
Date: Thu, 30 May 2013 18:18:22 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DCB38A@US01WEMBX2.internal.synopsys.com>
References: <1369909447-36368-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1369909447-36368-1-git-send-email-wangyijing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Yijing Wang [mailto:wangyijing@huawei.com]
> Sent: Thursday, May 30, 2013 3:24 AM
> 
> Pci_enable_device() will set device power state to D0,
> so it's no need to do it again in dwc2_driver_probe().
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/staging/dwc2/pci.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/dwc2/pci.c b/drivers/staging/dwc2/pci.c
> index 69c65eb..6a196c2 100644
> --- a/drivers/staging/dwc2/pci.c
> +++ b/drivers/staging/dwc2/pci.c
> @@ -131,8 +131,6 @@ static int dwc2_driver_probe(struct pci_dev *dev,
>  	if (!hsotg)
>  		return -ENOMEM;
> 
> -	pci_set_power_state(dev, PCI_D0);
> -
>  	hsotg->dev = &dev->dev;
>  	hsotg->regs = devm_request_and_ioremap(&dev->dev, &dev->resource[0]);
>  	if (!hsotg->regs)
> --
> 1.7.1

Acked-by: Paul Zimmerman <paulz@synopsys.com>

