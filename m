Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbaAaSV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:21:57 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:44585 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbaAaSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:21:55 -0500
Message-ID: <52EBF7DE.3080003@cogentembedded.com>
Date: Fri, 31 Jan 2014 22:22:06 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>, Amir Vadai <amirv@mellanox.com>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 18/34] mlx4: Use pci_enable_msix_range()
References: <cover.1391172839.git.agordeev@redhat.com> <2f6674dabb90d4cbca3ef4039c3b893f2e5e9ec4.1391172839.git.agordeev@redhat.com>
In-Reply-To: <2f6674dabb90d4cbca3ef4039c3b893f2e5e9ec4.1391172839.git.agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/31/2014 06:08 PM, Alexander Gordeev wrote:

> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/main.c |   19 ++++---------------
>   1 files changed, 4 insertions(+), 15 deletions(-)

> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index d711158..a9d1249 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
[...]
> @@ -1990,22 +1989,12 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
[...]
> +		nreq = pci_enable_msix_range(dev->pdev, entries, 2, nreq);
> +
> +		if (nreq < 0) {
>   			kfree(entries);
>   			goto no_msi;
> -		}
> -
> -		if (nreq <
> +		} else if (nreq <
>   		    MSIX_LEGACY_SZ + dev->caps.num_ports * MIN_MSIX_P_PORT) {

    Please realign this line to start right under 'nreq'.

WBR, Sergei

