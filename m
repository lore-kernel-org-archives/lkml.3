Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbaDPUtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:49:22 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:33134 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbaDPUtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:49:21 -0400
Date: Wed, 16 Apr 2014 16:49:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, guohanjun@huawei.com,
        Kefeng Wang <kefeng.wang@linaro.org>
Subject: Re: [PATCH V2 2/2] ahci: add support for Hisilicon sata
Message-ID: <20140416204917.GB26632@htj.dyndns.org>
References: <1397107468-640-1-git-send-email-wangkefeng.wang@huawei.com>
 <1397107468-640-3-git-send-email-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397107468-640-3-git-send-email-wangkefeng.wang@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 10, 2014 at 01:24:28PM +0800, Kefeng Wang wrote:
> From: Kefeng Wang <kefeng.wang@linaro.org>
> 
> The hip04 SoC of hisilicon has an AHCI compliant SATA controller,
> and it is compliant with the ahci 1.3 and sata 3.0 specification.
> 
> There is a wrong bit in HOST_CAP of hip04 sata controller, which
> enable unsupported feature of FBS, use AHCI_HFLAG_NO_FBS hflag to
> disable it.
> 
> Cc: Hans de Geode <hdegoede@redhat.com>
> Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
> @@ -54,8 +55,10 @@ static int ahci_probe(struct platform_device *pdev)
>  		if (rc)
>  			goto disable_resources;
>  	}
> +	if (of_device_is_compatible(pdev->dev.of_node, "hisilicon,hisi-ahci"))
> +		pi.private_data = (void *)AHCI_HFLAG_NO_FBS;

Hmmm.... this should work but looks a bit tedious and it could be
better to have a better mechanism to match devices to their
port_infos.  Hans, can you please comment?  If getting something more
structured is too much work, I can go with this but wanna find out
whether that's the case.

Thanks.

-- 
tejun
