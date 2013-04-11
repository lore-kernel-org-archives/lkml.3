Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740Ab3DKLzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 07:55:12 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:58121 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3DKLzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 07:55:10 -0400
Message-ID: <5166A487.8060704@huawei.com>
Date: Thu, 11 Apr 2013 19:54:47 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>
Subject: Re: [PATCH -v2] PCI/VFIO: use pcie_flags_reg instead of access PCI-E
 Capabilities Register
References: <1364867547-15300-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1364867547-15300-1-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On 2013/4/2 9:52, Yijing Wang wrote:
> Currently, we use pcie_flags_reg to cache PCI-E Capabilities Register,
> because PCI-E Capabilities Register bits are almost read-only. This patch
> use pcie_caps_reg() instead of another access PCI-E Capabilities Register.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index aeb00fc..12a81f7 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1017,13 +1017,9 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
>  		return byte;
>  	case PCI_CAP_ID_EXP:
>  		/* length based on version */
> -		ret = pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &word);
> -		if (ret)
> -			return pcibios_err_to_errno(ret);
> -
>  		vdev->extended_caps = true;
>  
> -		if ((word & PCI_EXP_FLAGS_VERS) == 1)
> +		if ((pcie_caps_reg(pdev) & PCI_EXP_FLAGS_VERS) == 1)
>  			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V1;
>  		else
>  			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V2;
> 


-- 
Thanks!
Yijing

