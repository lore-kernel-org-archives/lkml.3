Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3HWNVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:21:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47940 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3HWNVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:21:46 -0400
X-AuditID: cbfee68e-b7f756d000004512-4a-521761e89553
Message-id: <521761F1.60203@samsung.com>
Date: Fri, 23 Aug 2013 22:21:53 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mmc: dw_mmc: Honor requests to set the clock to 0
 (turn off clock)
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
 <1377188348-3418-3-git-send-email-dianders@chromium.org>
In-reply-to: <1377188348-3418-3-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkQPdFoniQwd8LuhaP1yxmsngwbxub
	xfbXG9kszi47yGbx6sgPJot3814wW1zeNYfN4sj/fkaLU9c/s1l8uH+R2WLVrj+MDtwesxsu
	snjsnHWX3aNn5xlGj0NX1jJ6XDnRxOrRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGR3HdrAU
	nBWv6P13jrmB8YhQFyMHh4SAicSB31JdjJxAppjEhXvr2boYuTiEBJYySpxe+J4FImEi0dh1
	lhUiMZ1R4vKLyVBVrxkl7p0+ygYyiVdAQ+LSSRWQBhYBVYmzLy+zgthsAjoS278dZwKxRQXC
	JF682sUMYvMKCEr8mHwPbIGIgKbEs4aXYHFmgbdMEhO2qYHYwgIJEndPX2UFGS8kUC9x7oE3
	SJhTwFWi+1gPVLmOxP7WaWwQtrzE5jVvmUFOkxD4yy5x5dk9Zoh7BCS+TT7EAvGwrMSmA8wQ
	f0lKHFxxg2UCo9gsJBfNQjJ2FpKxCxiZVzGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIExuvp
	f8/6djDePGB9iDEZaOVEZinR5HxgvOeVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKa
	nZpakFoUX1Sak1p8iJGJg1OqgdFIZNW8V+6eraYaYZUHDNym3NPaYZLeVlfgb+KleECw4Mzs
	r7rLzi9f93rCyTLlhe07rGzyQ1uKuCc1l3yOXP0g2C1mfvbEOZt8VJZeExH9+UktQFd+dvk6
	hk2/8uLybpwTtVV4/nyf0ARTaS15tVNXpep2d7yKOcr0QdApeNpbveIbui0ZZUosxRmJhlrM
	RcWJAD4LWYXtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jQd0XieJBBlNuqFg8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHF51xw2iyP/+xktTl3/zGbx4f5FZotVu/4wOnB7zG64
	yOKxc9Zddo+enWcYPQ5dWcvoceVEE6tH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXb
	KnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2ppFCWmFMKFApILC5W0rfDNCE0xE3X
	AqYxQtc3JAiux8gADSSsYczoOLaDpeCseEXvv3PMDYxHhLoYOTkkBEwkGrvOskLYYhIX7q1n
	62Lk4hASmM4ocfnFZCjnNaPEvdNHgRwODl4BDYlLJ1VAGlgEVCXOvrwM1swmoCOx/dtxJhBb
	VCBM4sWrXcwgNq+AoMSPyfdYQGwRAU2JZw0vweLMAm+ZJCZsUwOxhQUSJO6evsoKMl5IoF7i
	3ANvkDCngKtE97EeqHIdif2t09ggbHmJzWveMk9gFJiFZMMsJGWzkJQtYGRexSiaWpBcUJyU
	nmukV5yYW1yal66XnJ+7iRGcDp5J72Bc1WBxiFGAg1GJh3eCs1iQEGtiWXFl7iFGCQ5mJRHe
	j9LiQUK8KYmVValF+fFFpTmpxYcYk4EBMJFZSjQ5H5iq8kriDY1NzIwsjcwNLYyMzUkTVhLn
	PdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBkatld9PlTervp/tnhm49sWjdtpjIKZKLbq632XTS
	Karv23LRRUqXLWc23bZQ4beIF/otYcn8QbI8Y2NfbsY9gQSh7UttfZY3bTsxjde4qb2Tda76
	oncPZX+fnBB/vP63X7rr1a08SZJfL8vdKksKdju94UCK8uRg1ucP/Pbu/27E8Fuq6lijrhJL
	cUaioRZzUXEiADTxAgFLAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

If the clock-gating is enabled, then maybe it's continuously printed the kernel message for Bus_speed.

Best Regards,
Jaehoon Chung

On 08/23/2013 01:19 AM, Doug Anderson wrote:
> Previously the dw_mmc driver would ignore any requests to disable the
> card's clock.  This doesn't seem like a good thing in general, but had
> one extra bad side effect in the following situtation:
> * mmc core would set clk to 400kHz at boot time while initting
> * mmc core would set clk to 0 since no card, but it would be ignored.
> * suspend to ram and resume; clocks in the dw_mmc IP block are now 0
>   but dw_mmc thinks that they're 400kHz (it ignored the set to 0).
> * insert card
> * mmc core would set clk to 400kHz which would be considered a no-op.
> 
> Note that if there is no card in the slot and we do a suspend/resume
> cycle, we _do_ still end up with differences in a dw_mmc register
> dump, but the differences are clock related and we've got the clock
> disabled both before and after, so this should be OK.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v6:
> - Replaces previous pathes that ensured saving/restoring clocks.
> 
>  drivers/mmc/host/dw_mmc.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index ee5f167..f6c7545 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -635,7 +635,11 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>  	u32 div;
>  	u32 clk_en_a;
>  
> -	if (slot->clock != host->current_speed || force_clkinit) {
> +	if (slot->clock == 0) {
> +		mci_writel(host, CLKENA, 0);
> +		mci_send_cmd(slot,
> +			     SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
> +	} else if (slot->clock != host->current_speed || force_clkinit) {
>  		div = host->bus_hz / slot->clock;
>  		if (host->bus_hz % slot->clock && host->bus_hz > slot->clock)
>  			/*
> @@ -675,9 +679,8 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>  		/* inform CIU */
>  		mci_send_cmd(slot,
>  			     SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
> -
> -		host->current_speed = slot->clock;
>  	}
> +	host->current_speed = slot->clock;
>  
>  	/* Set the current slot bus width */
>  	mci_writel(host, CTYPE, (slot->ctype << slot->id));
> @@ -807,13 +810,11 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  
>  	mci_writel(slot->host, UHS_REG, regs);
>  
> -	if (ios->clock) {
> -		/*
> -		 * Use mirror of ios->clock to prevent race with mmc
> -		 * core ios update when finding the minimum.
> -		 */
> -		slot->clock = ios->clock;
> -	}
> +	/*
> +	 * Use mirror of ios->clock to prevent race with mmc
> +	 * core ios update when finding the minimum.
> +	 */
> +	slot->clock = ios->clock;
>  
>  	if (drv_data && drv_data->set_ios)
>  		drv_data->set_ios(slot->host, ios);
> 

