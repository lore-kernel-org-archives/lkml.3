Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627Ab3JOTWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:22:15 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34940 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab3JOTWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:22:11 -0400
Message-ID: <525D95A4.3020706@cogentembedded.com>
Date: Tue, 15 Oct 2013 23:21:08 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC 4/5] net: macb: Use devm_request_irq()
References: <1381795140-10792-1-git-send-email-soren.brinkmann@xilinx.com> <1381795140-10792-5-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1381795140-10792-5-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/15/2013 03:58 AM, Soren Brinkmann wrote:

> Use the device managed interface to request the IRQ, simplifying error
> paths.

> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>   drivers/net/ethernet/cadence/macb.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)

> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index 436aecc31732..603844b1d483 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -1825,7 +1825,8 @@ static int __init macb_probe(struct platform_device *pdev)
>   	}
>
>   	dev->irq = platform_get_irq(pdev, 0);
> -	err = request_irq(dev->irq, macb_interrupt, 0, dev->name, dev);
> +	err = devm_request_irq(&pdev->dev, dev->irq, macb_interrupt, 0,
> +			dev->name, dev);

    You should start the continuation line right under &.

WBR, Sergei

