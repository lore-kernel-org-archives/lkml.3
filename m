Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab3BGLWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:22:06 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:35490 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab3BGLWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:22:03 -0500
Message-ID: <51138E41.3080708@mvista.com>
Date: Thu, 07 Feb 2013 15:21:37 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Kumar, Anil" <anilkumar.v@ti.com>
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, wim@iguana.be
Subject: Re: [PATCH] watchdog: davinci_wdt: update to devm_* API
References: <1360207935-24325-1-git-send-email-anilkumar.v@ti.com>
In-Reply-To: <1360207935-24325-1-git-send-email-anilkumar.v@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-02-2013 7:32, Kumar, Anil wrote:

> Update the code to use devm_* API so that driver
> core will manage resources.

> Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> ---
> This patch applies on top of v3.8-rc6.

> Tested on da850 EVM.

> :100644 100644 e8e8724... 6ad76a3... M	drivers/watchdog/davinci_wdt.c
>   drivers/watchdog/davinci_wdt.c |   34 +++++++++-------------------------
>   1 files changed, 9 insertions(+), 25 deletions(-)

> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> index e8e8724..6ad76a3 100644
> --- a/drivers/watchdog/davinci_wdt.c
> +++ b/drivers/watchdog/davinci_wdt.c
[...]
> @@ -213,49 +212,34 @@ static int davinci_wdt_probe(struct platform_device *pdev)
[...]
> -	size = resource_size(wdt_mem);
> -	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
> -		dev_err(dev, "failed to get memory region\n");
> -		return -ENOENT;
> -	}
> -
> -	wdt_base = ioremap(wdt_mem->start, size);
> +	wdt_base = devm_request_and_ioremap(&pdev->dev, wdt_mem);
>   	if (!wdt_base) {
> -		dev_err(dev, "failed to map memory region\n");
> -		release_mem_region(wdt_mem->start, size);
> -		wdt_mem = NULL;
> +		dev_err(&pdev->dev, "ioremap failed\n");
>   		return -ENOMEM;

    Comment to devm_request_and_ioremap() suggest returning -EADDRNOTAVAIL 
instead.

WBR, Sergei

