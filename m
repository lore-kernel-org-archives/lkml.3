Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaFJKHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:07:49 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52088 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaFJKHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:07:47 -0400
Message-ID: <5396D8C9.6020607@linaro.org>
Date: Tue, 10 Jun 2014 18:07:05 +0800
From: "kefeng.wang" <kefeng.wang@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Hans de Goede <hdegoede@redhat.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
        xuwei5@hisilicon.com
Subject: Re: [PATCH] ahci: disable ncq feature for hisilicon sata
References: <1398416351-30567-1-git-send-email-kefeng.wang@linaro.org> <20140514170757.GD15690@htj.dyndns.org> <5396D529.308@linaro.org>
In-Reply-To: <5396D529.308@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

I have a question, the hip04 and hix5hd2 soc use the old version of IP, but they
also have a new version of IP which support FBS and NCQ, and now the new one is
used by a new soc. How can I distinguish them, use "hisilicon,hisi-ahci-vX" or just
add "generic-ahci" string for the IP which is conformant with spec and has
no special customization and issue? Any advices, thanks.

Regards,
Kefeng

On 2014-6-10 17:51, kefeng.wang wrote:
> NCQ feature is unsupported on hisilicon sata controller, so disable it.
> This version of IP is used by hip04 and hix5hd2 soc.
> 
> Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
> ---
>  drivers/ata/ahci_platform.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index ebe505c..0cfda8b 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -58,7 +58,7 @@ static int ahci_probe(struct platform_device *pdev)
>         }
> 
>         if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
> -               hflags |= AHCI_HFLAG_NO_FBS;
> +               hflags = AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;
> 
>         rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info,
>                                      hflags, 0, 0);
> 

