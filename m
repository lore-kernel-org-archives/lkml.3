Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812Ab3E3Pbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:31:46 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34190 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab3E3Pbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:31:39 -0400
MIME-Version: 1.0
In-Reply-To: <1369909626-37832-1-git-send-email-wangyijing@huawei.com>
References: <1369909626-37832-1-git-send-email-wangyijing@huawei.com>
Date: Thu, 30 May 2013 08:31:38 -0700
Message-ID: <CAP6odjieAiXxotVpE6fyFp7KS-1GXHdKpWXymtT96fRek5ewoQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] tulip: remove redundant D0 power state set
From: Grant Grundler <grantgrundler@gmail.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 3:27 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> Pci_enable_device() will set device power state to D0,
> so it's no need to do it again in tulip_init_one().
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Ack-by: Grant Grundler <grundler@parisc-linux.org>

thanks!
grant

> ---
>  drivers/net/ethernet/dec/tulip/tulip_core.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
> index 1e9443d..c94152f 100644
> --- a/drivers/net/ethernet/dec/tulip/tulip_core.c
> +++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
> @@ -1410,12 +1410,6 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>                 return i;
>         }
>
> -       /* The chip will fail to enter a low-power state later unless
> -        * first explicitly commanded into D0 */
> -       if (pci_set_power_state(pdev, PCI_D0)) {
> -               pr_notice("Failed to set power state to D0\n");
> -       }
> -
>         irq = pdev->irq;
>
>         /* alloc_etherdev ensures aligned and zeroed private structures */
> --
> 1.7.1
>
>
