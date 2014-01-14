Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaANMDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:03:48 -0500
Received: from nbd.name ([46.4.11.11]:53859 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbaANMDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:03:46 -0500
Message-ID: <52D52796.3030509@phrozen.org>
Date: Tue, 14 Jan 2014 13:03:34 +0100
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH 1/7] arch/mips/lantiq/xway: don't check resource with
 devm_ioremap_resource
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

should we take 1/7 and 6/7 via the mips tree ?

    John


On 14/01/2014 12:58, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Acked-by: John Crispin <blogic@openwrt.org>
> ---
>
> Should go via subsystem tree
>
>  arch/mips/lantiq/xway/dma.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
> index 08f7ebd..78a91fa 100644
> --- a/arch/mips/lantiq/xway/dma.c
> +++ b/arch/mips/lantiq/xway/dma.c
> @@ -220,10 +220,6 @@ ltq_dma_init(struct platform_device *pdev)
>  	int i;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		panic("Failed to get dma resource");
> -
> -	/* remap dma register range */
>  	ltq_dma_membase = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(ltq_dma_membase))
>  		panic("Failed to remap dma resource");

