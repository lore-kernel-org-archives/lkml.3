Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaFZG2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 02:28:31 -0400
Received: from mout.gmx.com ([74.208.4.201]:59750 "EHLO mout.gmx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbaFZG23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 02:28:29 -0400
Date: Thu, 26 Jun 2014 11:57:51 +0530 (IST)
From: Govindarajulu Varadarajan <_govind@gmx.com>
X-X-Sender: gvaradar@ws.cisco
To: Joe Perches <joe@perches.com>
cc: linux-kernel@vger.kernel.org, Christian Benvenuti <benve@cisco.com>,
        Sujith Sankar <ssujith@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Neel Patel <neepatel@cisco.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 10/22] enic: Use pci_zalloc_consistent
In-Reply-To: <cfd907966b8feaaa1c2ecbd537a7a0ef3fc98141.1403530604.git.joe@perches.com>
Message-ID: <alpine.LNX.2.03.1406261157070.1438@ws.cisco>
References: <cover.1403530604.git.joe@perches.com> <cfd907966b8feaaa1c2ecbd537a7a0ef3fc98141.1403530604.git.joe@perches.com>
User-Agent: Alpine 2.03 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V03:K0:w7WpRFh/KXSzH872tKkA74bkSObjpo95mj+kliiHVsBlYFh1T5q
 AlVQR+Lc8AcLjK1rckSEUz8Xkcruuvd45dA9g+xUZDP1TMxh67xlS93YFsm0P/4iAH7G88r
 i89/s2R/2H+MNZeqV/p2CGLoWn1pDBZTnhUjpgPnM1bc/r/B2V5DSss4vr3DsjZOE+wSTB5
 yYU9Xr0yyH+HIHnoEEU3Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jun 2014, Joe Perches wrote:

> Remove the now unnecessary memset too.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Looks good, thanks
Acked-by: Govindarajulu Varadarajan <_govind@gmx.com>

> ---
> drivers/net/ethernet/cisco/enic/vnic_dev.c | 8 +++-----
> 1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/cisco/enic/vnic_dev.c b/drivers/net/ethernet/cisco/enic/vnic_dev.c
> index e86a45c..8a4799c 100644
> --- a/drivers/net/ethernet/cisco/enic/vnic_dev.c
> +++ b/drivers/net/ethernet/cisco/enic/vnic_dev.c
> @@ -432,14 +432,12 @@ int vnic_dev_fw_info(struct vnic_dev *vdev,
> 	int err = 0;
>
> 	if (!vdev->fw_info) {
> -		vdev->fw_info = pci_alloc_consistent(vdev->pdev,
> -			sizeof(struct vnic_devcmd_fw_info),
> -			&vdev->fw_info_pa);
> +		vdev->fw_info = pci_zalloc_consistent(vdev->pdev,
> +						      sizeof(struct vnic_devcmd_fw_info),
> +						      &vdev->fw_info_pa);
> 		if (!vdev->fw_info)
> 			return -ENOMEM;
>
> -		memset(vdev->fw_info, 0, sizeof(struct vnic_devcmd_fw_info));
> -
> 		a0 = vdev->fw_info_pa;
> 		a1 = sizeof(struct vnic_devcmd_fw_info);
>
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
>
>
