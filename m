Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3DLKYC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 06:24:02 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:46252 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab3DLKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 06:23:59 -0400
Message-ID: <5167E0BD.5080808@pobox.com>
Date: Fri, 12 Apr 2013 06:23:57 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: ata: rcar: use devm_ioremap_resource()
References: <1365749477-22770-1-git-send-email-silviupopescu1990@gmail.com>
In-Reply-To: <1365749477-22770-1-git-send-email-silviupopescu1990@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 02:51 AM, Silviu-Mihai Popescu wrote:
> Convert  use of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> This was found with coccinelle.
>
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
>   drivers/ata/sata_rcar.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
> index caf33f6..8c51a3a 100644
> --- a/drivers/ata/sata_rcar.c
> +++ b/drivers/ata/sata_rcar.c
> @@ -799,9 +799,9 @@ static int sata_rcar_probe(struct platform_device *pdev)
>
>   	host->private_data = priv;
>
> -	priv->base = devm_request_and_ioremap(&pdev->dev, mem);
> -	if (!priv->base) {
> -		ret = -EADDRNOTAVAIL;
> +	priv->base = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(priv->base)) {
> +		ret = PTR_ERR(priv->base);
>   		goto cleanup;
>   	}
>
>

See 2de1d5e159ccf317a9285a0dfaa6e4262500d7dd in libata-dev.git#upstream.

	Jeff




