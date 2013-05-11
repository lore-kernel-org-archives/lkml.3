Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3EKUf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 16:35:29 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:54356 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3EKUf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 16:35:28 -0400
Message-ID: <518EAB9B.8040106@cogentembedded.com>
Date: Sun, 12 May 2013 00:35:39 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC 17/42] drivers/net/ethernet/renesas: don't check resource
 with devm_ioremap_resource
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de> <1368173847-5661-18-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1368173847-5661-18-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/10/2013 12:17 PM, Wolfram Sang wrote:

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>   drivers/net/ethernet/renesas/sh_eth.c |   14 +-------------
>   1 file changed, 1 insertion(+), 13 deletions(-)
>
> diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
> index 33dc6f2..6175839 100644
> --- a/drivers/net/ethernet/renesas/sh_eth.c
> +++ b/drivers/net/ethernet/renesas/sh_eth.c
> @@ -2661,14 +2661,6 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
>   	struct sh_eth_private *mdp = NULL;
>   	struct sh_eth_plat_data *pd = pdev->dev.platform_data;
>   
> -	/* get base addr */
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (unlikely(res == NULL)) {
> -		dev_err(&pdev->dev, "invalid resource\n");
> -		ret = -EINVAL;
> -		goto out;
> -	}
> -
>   	ndev = alloc_etherdev(sizeof(struct sh_eth_private));
>   	if (!ndev) {
>   		ret = -ENOMEM;

     There's ndev->base_addr = res->start; below this which you broke. NAK.
You should really compile-test your patches.

WBR, Sergei

