Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3HHFOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 01:14:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47054 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab3HHFOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 01:14:50 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-be-520329475f70
Message-id: <5203294D.4000801@samsung.com>
Date: Thu, 08 Aug 2013 14:14:53 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/4] mmc: dw_mmc: Invalidate cache of current_speed
 after suspend/resume
References: <1373470926-19314-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-2-git-send-email-dianders@chromium.org>
In-reply-to: <1375825071-20922-2-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsWyRsSkWNddkznIYNoLa4vHaxYzWTyYt43N
	YvvrjWwWZ5cdZLN4deQHk8W7eS+YLW78amO1uLxrDpvFkf/9jBanrn9ms/hw/yKzxapdfxgd
	eDxmN1xk8dg56y67R8/OM4weh66sZfS4cqKJ1aNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgy
	OqeuYypYKlzx5doZpgbGCfxdjBwcEgImEgfeBHQxcgKZYhIX7q1n62Lk4hASWMoosW5nKytE
	wkTi8oJpUIlFjBKHnl5kgnBeM0rMvdwNVsUroCVx7OgmJhCbRUBV4mDjNXYQm01AR2L7t+Ng
	cVGBMIkl3x6zQdQLSvyYfI8FxBYR0JR41vCSGWQos8BUZolz6/+ANQsLJErcmnCEBWLbXkaJ
	m2svg23jFHCTeN/+BqyIGWjD/tZpbBC2vMTmNW/BJkkItHJI9C9bwwZxkoDEt8mHWCCelpXY
	dIAZ4jdJiYMrbrBMYBSbheSoWUjGzkIydgEj8ypG0dSC5ILipPQiE73ixNzi0rx0veT83E2M
	wAg+/e/ZhB2M9w5YH2JMBlo5kVlKNDkfmADySuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cBoabNZd29sxv/7m70WfVKNsTl46uasz9pFv6TFxd5N
	TA7aFHzFS6zqt1hUQfi1fNtHCjp/J8c6yiVoV15wZ7HPaqu/6fH7q7Bk2csKmSsfktIsLXQt
	j+pyyVY9mGe8w92PuzvU/dTPtuDwC+a/JihcLDqyKHiSmGCwxXzG//n3Ll669vrv5HlKLMUZ
	iYZazEXFiQCVyyJj9gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAV13TeYgg409xhaP1yxmsngwbxub
	xfbXG9kszi47yGbx6sgPJot3814wW9z41cZqcXnXHDaLI//7GS1OXf/MZvHh/kVmi1W7/jA6
	8HjMbrjI4rFz1l12j56dZxg9Dl1Zy+hx5UQTq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaqkUJaYUwoUCkgsLlbSt8M0
	ITTETdcCpjFC1zckCK7HyAANJKxhzOicuo6pYKlwxZdrZ5gaGCfwdzFyckgImEhcXjCNDcIW
	k7hwbz2QzcUhJLCIUeLQ04tMEM5rRom5l7tZQap4BbQkjh3dxARiswioShxsvMYOYrMJ6Ehs
	/3YcLC4qECax5NtjNoh6QYkfk++xgNgiApoSzxpeMoMMZRaYyixxbv0fsGZhgUSJWxOOsEBs
	28socXPtZbBtnAJuEu/b34AVMQNt2N8KcSuzgLzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAhOEM+kdzCuarA4xCjAwajEw9sRwBQkxJpYVlyZe4hR
	goNZSYT3YjFQiDclsbIqtSg/vqg0J7X4EGMyMAwmMkuJJucDk1deSbyhsYmZkaWRuaGFkbE5
	acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTAqKvzftWP3LKMP/R1Hpn+ceqW0ecrt95r9
	U488flKVrGwe63LC892SuBXb2w9xl6kJp22qWcD95a1U8gO3KaenCotvY1yxwFdVJHz2KzfN
	T/krVJK+NEzO3r2qcV66fur/jremE27cTHF8n7ViFSdnz4YgS1u2wPyHPt0Rm+OrduVZ1KTL
	uLErsRRnJBpqMRcVJwIA86lf3FQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doung

On 08/07/2013 06:37 AM, Doug Anderson wrote:
> The dw_mmc driver keeps a cache of the current slot->clock in order to
> avoid doing a whole lot of work every time set_ios() is called.
> However, after suspend/resume the register values are bogus so we need
> to ensure that the cached value is invalidated.
> 
> In many cases we got by without this since the core mmc code fiddles
> with the clock a lot.  If we've got a card present we're probably
> running it at something like 50MHz and the core will temporarily
> switch us to 400kHz after resume.  One case that didn't work (for me)
> is the case of having no card in the slot.  The slot is initted to
> 400kHz at boot time.  After suspend/resume the slot thinks it's still
> at 400kHz (due to the cache) so doesn't adjust timing.  When it tries
> to send the command at probe time it just times out and gets left in a
> bad state.
> 
> Invalidating the current_speed also means that we don't need to call:
>   dw_mci_setup_bus(slot, true);
> ...to force an update of the clock in the case when the slot was left
> powered.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v4: None
> Changes in v3: None
> Changes in v2:
> - Fix typo (some -> come)
> - Use ~0 instead of 0xFFFFFFFF; add comment about value
> 
>  drivers/mmc/host/dw_mmc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index ee5f167..13a363c 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2511,13 +2511,19 @@ int dw_mci_resume(struct dw_mci *host)
>  		   DW_MCI_ERROR_FLAGS | SDMMC_INT_CD);
>  	mci_writel(host, CTRL, SDMMC_CTRL_INT_ENABLE);
>  
> +	/*
> +	 * Invalidate the 'current_speed' value since CLKDIV has come up in
> +	 * default state and our cache is incorrect; set to something we know
> +	 * slot->clock won't be.
> +	 */
> +	host->current_speed = ~0;
> +
>  	for (i = 0; i < host->num_slots; i++) {
>  		struct dw_mci_slot *slot = host->slot[i];
>  		if (!slot)
>  			continue;
>  		if (slot->mmc->pm_flags & MMC_PM_KEEP_POWER) {
>  			dw_mci_set_ios(slot->mmc, &slot->mmc->ios);
> -			dw_mci_setup_bus(slot, true);
If we need not to call dw_mci_setup_bus() at here,
the we can also remove the "force_clkinit".

Best Regards,
Jaehoon Chung
>  		}
>  
>  		ret = mmc_resume_host(host->slot[i]->mmc);
> 

