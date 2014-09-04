Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbaIDFV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:21:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47139 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaIDFVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:21:55 -0400
X-AuditID: cbfee691-f79546d0000011a1-1f-5407f6f1c6f1
Message-id: <5407F6F1.60900@samsung.com>
Date: Thu, 04 Sep 2014 14:21:53 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, chris@printf.net,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mmc: dw_mmc: Don't enable interrupts until we're ready
References: <1409701034-28526-1-git-send-email-dianders@chromium.org>
In-reply-to: <1409701034-28526-1-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWyRsSkWPfjN/YQg7ntUhbL/n9nsphweTuj
	xdllB9ksbvxqY7XY9Pgaq8XlXXPYLI7872e0eHJmJqPFh/sXmS2Orw134PKY3XCRxePOtT1s
	HpuX1HvceLWQyePvrP0sHn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJXx69k91oI5UhXvfn1h
	aWD8LdLFyMkhIWAicfPtYnYIW0ziwr31bF2MXBxCAksZJVp+zmeHKbr+6yUjRGIRo8STheuY
	QBJCAq8ZJf5NjAaxeQU0JFp/7AWLswioSky4upwZxGYT0JHY/u04WFxUIEziUNs8Joh6QYkf
	k++xgAwVEVjIKPH750FWEIdZYA+jxPJTsxlBqoQFvCVazp1nhdjmKnHpyjcwm1PATeL2u+ts
	IDYz0Ib9rdOgbHmJzWveMoMMkhD4yC7RteAfO8RJAhLfJh8CWscBlJCV2HSAGeI1SYmDK26w
	TGAUm4XkqFlIxs5CMnYBI/MqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjMBIPf3v2cQdjPcP
	WB9iFOBgVOLhLXjBHiLEmlhWXJl7iNEU6IqJzFKiyfnAdJBXEm9obGZkYWpiamxkbmmmJM6r
	I/0zWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjmmv2D+cFZq81rbSfTNrXWLbls8+lt60c
	B2olErL9tnDMkz5xfsf2dx5dvT7usy/zOjOuPcb3fuE/paNfLkje2m/TI5nPKKk951FOEEvR
	7JLGte1C+26ZiOlWbNumMvfdAe8TgUxtL+zjUrZEJzzqf7PrYfb6U5px7fnn+O6llixTDoxb
	LfBBiaU4I9FQi7moOBEAuU25Q88CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xgO7Hb+whBs+nClss+/+dyWLC5e2M
	FmeXHWSzuPGrjdVi0+NrrBaXd81hszjyv5/R4smZmYwWH+5fZLY4vjbcgctjdsNFFo871/aw
	eWxeUu9x49VCJo+/s/azePRtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjF/P7rEWzJGqePfrC0sD42+RLkZODgkBE4nrv14yQthiEhfurWfrYuTiEBJY
	xCjxZOE6JpCEkMBrRol/E6NBbF4BDYnWH3vB4iwCqhITri5nBrHZBHQktn87DhYXFQiTONQ2
	jwmiXlDix+R7LCBDRQQWMkr8/nmQFcRhFtjDKLH81Gyw1cIC3hIt586zQmxzlbh05RuYzSng
	JnH73XU2EJsZaMP+1mlQtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAhOA8+kdzCuarA4xCjAwajEw1vwgj1EiDWxrLgy9xCjBAezkgjv7LNAId6U
	xMqq1KL8+KLSnNTiQ4ymwDCYyCwlmpwPTFF5JfGGxiZmRpZG5oYWRsbmSuK8B1utA4UE0hNL
	UrNTUwtSi2D6mDg4pRoYJ/3YtkLodMBCfv+U6BUudtdsedQOn8+XtvIrDjz9cf8Jt4vtF+cv
	7jEKYTM+0NCqJeDLVXtsstJ1p4VbUt+c1tn2iN88a0V4w5Ts1HjRedu5pwTM2cL6/q5OWcST
	7mMbZJZ+2i2haa0/U8FrvkqU6o306eZvQhiurbJlYt0yXXHWX0kXUb5lSizFGYmGWsxFxYkA
	bYqJZxkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug

On 09/03/2014 08:37 AM, Doug Anderson wrote:
> On dw_mmc there's a small race if you happen to get a card detect
> interrupt at just the wrong time during probe.  You may have enabled
> the interrupt but host->slot[0] may be NULL.
> 
> Fix the race by enabling interrupts all the way at the end of the
> probe.  We can also use free_irq() instead of dw_mmc specific masking
> to mask the IRQ at removal time.  Note that since we're now managing
> freeing of the irq ourselves, there's no need to use devm.
> 
> FYI, the crash would look like:
>   dwmmc_rockchip ff0c0000.dwmmc: DW MMC controller at irq 64, 32 bit host data width, 256 deep fifo
>   Unable to handle kernel NULL pointer dereference at virtual address 00000000
>   pgd = c0004000
>   [00000000] *pgd=00000000
>   ...
>   ...
>   [<c0499380>] (dw_mci_work_routine_card) from [<c0134b94>] (process_one_work+0x260/0x3c4)
>   [<c0134b94>] (process_one_work) from [<c0135b10>] (worker_thread+0x240/0x3a8)
>   [<c0135b10>] (worker_thread) from [<c013b64c>] (kthread+0x100/0x118)
>   [<c013b64c>] (kthread) from [<c0106418>] (ret_from_fork+0x14/0x20)
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> FYI: making dw_mmc into a module and trying module removal was not
> tested.  I'd appreciate any testing that folks can do there.  This
> code should be the equivalent and makes the error case of probe match
> the removal case more closely now.
> 
>  drivers/mmc/host/dw_mmc.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 7f227e9..540ba3c 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2577,10 +2577,6 @@ int dw_mci_probe(struct dw_mci *host)
>  		goto err_dmaunmap;
>  	}
>  	INIT_WORK(&host->card_work, dw_mci_work_routine_card);
> -	ret = devm_request_irq(host->dev, host->irq, dw_mci_interrupt,
> -			       host->irq_flags, "dw-mci", host);
> -	if (ret)
> -		goto err_workqueue;
>  
>  	if (host->pdata->num_slots)
>  		host->num_slots = host->pdata->num_slots;
> @@ -2619,11 +2615,21 @@ int dw_mci_probe(struct dw_mci *host)
>  		goto err_workqueue;
>  	}
>  
> +	ret = request_irq(host->irq, dw_mci_interrupt, host->irq_flags,
> +			  "dw-mci", host);
> +	if (ret)
> +		goto err_initted;

I didn't test and consider race condition yet.
But if located "request_irq" at here, we can be confused something,
since there is "dev_info(host->dev, "%d slots initialized\n", init_slots)" message at above.

I think you can relocate this.

Best Regards,
Jaehoon Chung

> +
>  	if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO)
>  		dev_info(host->dev, "Internal DMAC interrupt fix enabled.\n");
>  
>  	return 0;
>  
> +err_initted:
> +	for (i = 0; i < host->num_slots; i++)
> +		if (host->slot[i])
> +			dw_mci_cleanup_slot(host->slot[i], i);
> +
>  err_workqueue:
>  	destroy_workqueue(host->card_workqueue);
>  
> @@ -2649,8 +2655,7 @@ void dw_mci_remove(struct dw_mci *host)
>  {
>  	int i;
>  
> -	mci_writel(host, RINTSTS, 0xFFFFFFFF);
> -	mci_writel(host, INTMASK, 0); /* disable all mmc interrupt first */
> +	free_irq(host->irq, host);
>  
>  	for (i = 0; i < host->num_slots; i++) {
>  		dev_dbg(host->dev, "remove slot %d\n", i);
> 

