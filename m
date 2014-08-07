Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbaHGQs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:48:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45937 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaHGQsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:48:25 -0400
X-AuditID: cbfee61b-f79f86d00000144c-46-53e3add79ecf
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] mfd: sec-irq: fix support for devices without irq specified
Date: Thu, 07 Aug 2014 18:48:21 +0200
Message-id: <1471646.xbSCysvkpT@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <22704524.WE4thfvSda@amdc1032>
References: <22704524.WE4thfvSda@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQd3rax8HG0w6L23x+oWhxdmmN+wW
	978eZbS4vGsOm8WM8/uYLE53s1pcXPGFyYHd4861PWwe804GevRtWcXo8XmTXABLFJdNSmpO
	Zllqkb5dAlfGlTM3WQu2cFa8+XmHpYHxI3sXIyeHhICJxPEd3cwQtpjEhXvr2boYuTiEBKYz
	SrTfP8YC4bQwSbTNmADWwSZgJTGxfRVjFyMHh4iAhsTenhqQGmaBl4wS3bP2MoHUCAsESPxZ
	ug/MZhFQlbi57DAriM0roClx+sAEFhBbVMBTYsf2lWwgNqeAtsSFif/A4kICWhLda96wQdQL
	SvyYfA8sziwgL7Fv/1RWCFtLYv3O40wTGAVmISmbhaRsFpKyBYzMqxhFUwuSC4qT0nON9IoT
	c4tL89L1kvNzNzGCw/qZ9A7GVQ0WhxgFOBiVeHgFuh8HC7EmlhVX5h5ilOBgVhLh1QUJ8aYk
	VlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYNRZf0D4OnfWuUUO
	xXHHHu18X71CYX79jM/yfoFadZOyfp7qdzqW9WKnwTXXDJEiLoGYVa2Gi7KbV73OlrrwJqx2
	yyapooSg5Nlmmo5/bSK0rZYKPMjeluP9JV78VaT/S8kmIYmCvbd142qel57Lzre/9s5MdLL4
	zB/rU9Mii3KvpU2Ks7Kcp8RSnJFoqMVcVJwIAHwrf+xnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added missing linux-samsung-soc ML, sorry for the noise ]

On Thursday, August 07, 2014 06:42:28 PM Bartlomiej Zolnierkiewicz wrote:
> Add missing check for the case of device without irq specified
> in sec_irq_exit() (please note that sec_irq_init() already
> correctly handles such devices).
> 
> This is needed for Insignal's Exynos4412 based Origen board.
> 
> Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Sangbeom Kim <sbkim73@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> patch is against next-20140804 branch of linux-next kernel
> 
>  drivers/mfd/sec-irq.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
> index f9a5786..b65a7f0 100644
> --- a/drivers/mfd/sec-irq.c
> +++ b/drivers/mfd/sec-irq.c
> @@ -478,5 +478,6 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
>  
>  void sec_irq_exit(struct sec_pmic_dev *sec_pmic)
>  {
> -	regmap_del_irq_chip(sec_pmic->irq, sec_pmic->irq_data);
> +	if (sec_pmic->irq)
> +		regmap_del_irq_chip(sec_pmic->irq, sec_pmic->irq_data);
>  }

