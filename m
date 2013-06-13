Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3FMFaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 01:30:14 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46185 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3FMFaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 01:30:12 -0400
Message-ID: <51B958D8.2070804@linaro.org>
Date: Thu, 13 Jun 2013 11:00:00 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: thierry.reding@gmail.com, patches@linaro.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 09/15] net: can: Convert to use devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-10-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1370864113-17895-10-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 05:05 PM, Tushar Behera wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: netdev@vger.kernel.org
> CC: linux-can@vger.kernel.org
> CC: Marc Kleine-Budde <mkl@pengutronix.de>
> CC: Wolfgang Grandegger <wg@grandegger.com>
> ---
>  drivers/net/can/c_can/c_can_platform.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
> index 6b6130b..b918c73 100644
> --- a/drivers/net/can/c_can/c_can_platform.c
> +++ b/drivers/net/can/c_can/c_can_platform.c
> @@ -201,8 +201,8 @@ static int c_can_plat_probe(struct platform_device *pdev)
>  			priv->instance = pdev->id;
>  
>  		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -		priv->raminit_ctrlreg =	devm_request_and_ioremap(&pdev->dev, res);
> -		if (!priv->raminit_ctrlreg || priv->instance < 0)
> +		priv->raminit_ctrlreg = devm_ioremap_resource(&pdev->dev, res);
> +		if (IS_ERR(priv->raminit_ctrlreg) || priv->instance < 0)
>  			dev_info(&pdev->dev, "control memory is not used for raminit\n");
>  		else
>  			priv->raminit = c_can_hw_raminit;
> 

IS_ERR() check on the return value of devm_ioremap_resource produces
following sparse warning. This is because of the __iomem address space
attribute. How should we fix this?

drivers/net/can/c_can/c_can_platform.c:205:32: warning: incorrect type
in argument 1 (different address spaces)
drivers/net/can/c_can/c_can_platform.c:205:32:    expected void const *ptr
drivers/net/can/c_can/c_can_platform.c:205:32:    got unsigned int
[noderef] [usertype] <asn:2>*raminit_ctrlreg


-- 
Tushar Behera
