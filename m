Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3HPKPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:15:48 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61259 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab3HPKPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:15:43 -0400
Message-ID: <520DFBC8.4040509@ozlabs.ru>
Date: Fri, 16 Aug 2013 20:15:36 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wei Yang <weiyang@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@au1.ibm.com, paulus@au1.ibm.com
Subject: Re: [PATCH 2/2] powerpc/iommu: check dev->iommu_group before remove
 a device from iommu_group
References: <1376647687-20550-1-git-send-email-weiyang@linux.vnet.ibm.com> <1376647687-20550-3-git-send-email-weiyang@linux.vnet.ibm.com>
In-Reply-To: <1376647687-20550-3-git-send-email-weiyang@linux.vnet.ibm.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 08:08 PM, Wei Yang wrote:
> ---
>  arch/powerpc/kernel/iommu.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index b20ff17..5abf7c3 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -1149,7 +1149,8 @@ static int iommu_bus_notifier(struct notifier_block *nb,
>  	case BUS_NOTIFY_ADD_DEVICE:
>  		return iommu_add_device(dev);
>  	case BUS_NOTIFY_DEL_DEVICE:
> -		iommu_del_device(dev);
> +		if (dev->iommu_group)
> +			iommu_del_device(dev);
>  		return 0;
>  	default:
>  		return 0;
> 

This one seems redundant, no?


-- 
Alexey
