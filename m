Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3HZEeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 00:34:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50814 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3HZEe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 00:34:29 -0400
X-AuditID: cbfee68e-b7f756d000004512-5a-521adad34389
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
 <1377188348-3418-3-git-send-email-dianders@chromium.org>
In-reply-to: <1377188348-3418-3-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v6 2/3] mmc: dw_mmc: Honor requests to set the clock to 0
 (turn off clock)
Date: Mon, 26 Aug 2013 13:34:26 +0900
Message-id: <001201cea215$8c125e30$a4371a90$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6fVCD/tR0GDp5+QKuVzjRJKPMdEgCv37jw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zQ93Lt6SCDDruclk8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurxeVdc9gsjvzvZ7Q4df0zm8WqXX8YHbg9Zjdc
	ZPHYOesuu0fPzjOMHoeurGX0uHKiidWjb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4Mk7tm8tS
	cFOq4uY3iwbGXtEuRk4OCQETieMTP7NA2GISF+6tZ+ti5OIQEljGKLF/7UcmmKIzs/cxQyQW
	MUpc6pjDCJIQEvjDKDH1dRGIzSagJfH3zRtmEFtEwEvixe4HYA3MAo+YJO4umQ3kcAA11Euc
	e+ANUsMp4CrRfawHrF5YIEGiaflOsJksAqoS3dt6wGxeAVuJj42NLBC2oMSPyffAbGYBA4n3
	s/pYIWx5ic1r3oKNlxBQl3j0VxfiBCOJSxfuMEGUiEjse/GOEeQcCYGpHBIfPhxihdglIPFt
	8iEWiF5ZiU0HmCH+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchIrzgx
	t7g0L10vOT93EyMk7vt2MN48YH2IMRlo/URmKdHkfGDayCuJNzQ2M7IwNTE1NjK3NCNNWEmc
	V63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD45yHe7elnWZ/5+v+5p2IQezlHStFrRdz
	331W+M0/jjPz3tZZqo2iv9/ob4nl0hRLm9jbe/eI8plss7X8Wu6rVnxcvkt6iVDOLzXnWnHZ
	4NOti6Zuldpg9epNiI++kuG3lc/C3L+vtL77bbHCat+v6c+U5jYm/XvyOj/0xGy5yoYzEm2B
	b9kXTVBiKc5INNRiLipOBAByK8cAEQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jAd3Lt6SCDP7PYbV4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi8u75rBZHPnfz2hx6vpnNotVu/4wOnB7zG64
	yOKxc9Zddo+enWcYPQ5dWcvoceVEE6tH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXb
	KnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2ppFCWmFMKFApILC5W0rfDNCE0xE3X
	AqYxQtc3JAiux8gADSSsY8w4tW8uS8FNqYqb3ywaGHtFuxg5OSQETCTOzN7HDGGLSVy4t56t
	i5GLQ0hgEaPEpY45jCAJIYE/jBJTXxeB2GwCWhJ/37wBaxAR8JJ4sfsBM0gDs8AjJom7S2YD
	ORxADfUS5x54g9RwCrhKdB/rAasXFkiQaFq+E2wmi4CqRPe2HjCbV8BW4mNjIwuELSjxY/I9
	MJtZwEDi/aw+VghbXmLzmrdg4yUE1CUe/dWFOMFI4tKFO0wQJSIS+168Y5zAKDQLyaRZSCbN
	QjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCk8ozqR2MKxssDjEKcDAq8fAG
	FkgFCbEmlhVX5h5ilOBgVhLhdXWQDBLiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGDCyyuJ
	NzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxvrW5zHzMv37kq+l
	RGzc9eCC5GlluciczULfnjcnci/iLUrv4Wr79MFp6gPmh7wzHJ8p8WfWamytT53soZJ6/2eh
	w48Fey7ICQU/udXOpVq+yF9jM0eY07aNJ3Z8k+zJWZo6SSmApT2W8ZSi6xHhcz8e3kr5kXbD
	v56pTWnuvMVJb5565Fx4qsRSnJFoqMVcVJwIABbGIH5uAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, August 23, 2013, Doug Anderson wrote:
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
Basically dw_mmc driver uses host's low power mode(auto clock gating)
So, how about keeping origin code rather than programming clock setting to '0'?
 
> +	} else if (slot->clock != host->current_speed || force_clkinit) {
And then, if condition('slot->clock is not zero') is added in order to allow to set clock,
print messages which Jaehoon pointed would be solved.

Thanks,
Seungwon Jeon

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
> --
> 1.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

