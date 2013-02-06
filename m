Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab3BFLwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:52:03 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:42503 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3BFLwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:52:01 -0500
Message-ID: <511243C8.8060400@mvista.com>
Date: Wed, 06 Feb 2013 15:51:36 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
CC: linux-i2c@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        ben-linux@fluff.org
Subject: Re: [PATCH V2] i2c: davinci: update to devm_* API
References: <1360149736-32523-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1360149736-32523-1-git-send-email-manishv.b@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06-02-2013 15:22, Vishwanathrao Badarkhe, Manish wrote:

> Update the code to use devm_* API so that driver
> core will manage resources.

> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> ---
> Changes since V1:
>    - Rebase on top of v3.8-rc6 of linus tree.
>    - Apply devm operation on clk_get.

> :100644 100644 6a0a553... da4e218... M	drivers/i2c/busses/i2c-davinci.c
>   drivers/i2c/busses/i2c-davinci.c |   45 +++++++++++---------------------------
>   1 files changed, 13 insertions(+), 32 deletions(-)

> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
> index 6a0a553..da4e218 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
[...]
> @@ -699,22 +693,24 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>   		dev->pdata = &davinci_i2c_platform_data_default;
>   	}
>
> -	dev->clk = clk_get(&pdev->dev, NULL);
> +	dev->clk = devm_clk_get(&pdev->dev, NULL);
>   	if (IS_ERR(dev->clk)) {
>   		r = -ENODEV;
>   		goto err_free_mem;
>   	}
>   	clk_prepare_enable(dev->clk);
>
> -	dev->base = ioremap(mem->start, resource_size(mem));
> +	dev->base = devm_request_and_ioremap(&pdev->dev, mem);
>   	if (!dev->base) {
>   		r = -EBUSY;

    Comment to devm_request_and_ioremap() suggests returning -EADDRNOTAVAIL on 
failure. -EBUSY wasn't the right code even before this change, should have 
been -ENOMEM.

WBR, Sergei

