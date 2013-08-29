Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3H2HFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:05:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab3H2HE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:04:58 -0400
X-AuditID: cbfee68e-b7f756d000004512-f9-521ef2925b94
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>
Cc: "'Chris Ball'" <cjb@laptop.org>, "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
 <1377188348-3418-3-git-send-email-dianders@chromium.org>
 <001201cea215$8c125e30$a4371a90$%jun@samsung.com>
 <521B1A87.4000500@samsung.com>
 <CAD=FV=WYMyGVmG-DXk1ke-yQCrfF74KDaZAUCW3qzf+Xfp-tpQ@mail.gmail.com>
In-reply-to: <CAD=FV=WYMyGVmG-DXk1ke-yQCrfF74KDaZAUCW3qzf+Xfp-tpQ@mail.gmail.com>
Subject: RE: [PATCH v6 2/3] mmc: dw_mmc: Honor requests to set the clock to 0
 (turn off clock)
Date: Thu, 29 Aug 2013 16:04:49 +0900
Message-id: <000301cea486$0d813eb0$2883bc10$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6idlvINzfAca7ySuau+UmhbxWolwCAeeSQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zQ91Jn+SCDPYtELZ4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi8u75rBZHPnfz2hx6vpnNotVu/4wOnB7zG64
	yOKxc9Zddo+enWcYPQ5dWcvoceVEE6tH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZfx92cRS
	sFS+4t7W90wNjHcluhg5OSQETCRmX/zDCGGLSVy4t54NxBYSWMYocXpbPUzN+TetQDVcQPHp
	jBKdi7sZIYr+MEo8P1QBYrMJaEn8ffOGuYuRg0NEIFxi700VkHpmgatMEtNurWaDaJ7NJNE4
	axk7SAOnQLDEnHUbwQYJCyRINC3fCWazCKhKvO7oB6vhFbCVeDZtEwuELSjxY/I9MJtZQE/i
	45/bjBC2vMTmNW/BFksIqEs8+qsLEhYRMJJY1DcHqkREYt+Ld2APSAjM5ZC4POENC8QuAYlv
	kw+xQPTKSmw6wAzxsKTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UVGesWJ
	ucWleel6yfm5mxghkd+3g/HmAetDjMlA6ycyS4km5wMTR15JvKGxmZGFqYmpsZG5pRlpwkri
	vGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGJfv/qwSHtNY1/Bp6Tb/E7/dmn42pq0V
	/HlrUaVBZNmrGVWr0632C1dsCVv9ymdh2UzD3T3PtR7nf1U59WPN4oV5+b+3xHyufrKrYrvY
	5xNPX616IscmbvvyulyKidc6dfF/jppTMsISml0TI8oqn95bHe2/WzAi55rxIXv1t6+znzI2
	qRUv71BiKc5INNRiLipOBAABOsMuEgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jQd1Jn+SCDJY+5LV4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi8u75rBZHPnfz2hx6vpnNotVu/4wOnB7zG64
	yOKxc9Zddo+enWcYPQ5dWcvoceVEE6tH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXb
	KnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2ppFCWmFMKFApILC5W0rfDNCE0xE3X
	AqYxQtc3JAiux8gADSSsY8z4+7KJpWCpfMW9re+ZGhjvSnQxcnJICJhInH/Tyghhi0lcuLee
	rYuRi0NIYDqjROfibrCEkMAfRonnhypAbDYBLYm/b94wdzFycIgIhEvsvakCUs8scJVJYtqt
	1VDNs5kkGmctYwdp4BQIlpizbiPYIGGBBImm5TvBbBYBVYnXHf1gNbwCthLPpm1igbAFJX5M
	vgdmMwvoSXz8c5sRwpaX2LzmLdhiCQF1iUd/dUHCIgJGEov65kCViEjse/GOcQKj0Cwkk2Yh
	mTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOLM+kdjCubLA4xCjAwajE
	wxvxWzZIiDWxrLgy9xCjBAezkgjvlzdyQUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0x6
	eSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAePQCx5b5jRkf
	FibxFBo1i8x9uujOuQ1mL1IFb874xn5Hp9XBom3vbP2ZZ9pKLj18dmTLy0+VgnwttrWPH28N
	WSpQZ/9nCu+hs3wXZVZdnbi0+kDM1Cy3jd9O79ja33m8drZFyIuvVw48OXcv5FTzHrNpa78r
	pV178uam0Io1Euohz4+yfZh+9zOTEktxRqKhFnNRcSIASvg26HADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 27, 2013, Doug Anderson wrote:
> Jaehoon / Seungwon,
> 
> On Mon, Aug 26, 2013 at 2:06 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> > On 08/26/2013 01:34 PM, Seungwon Jeon wrote:
> >> On Fri, August 23, 2013, Doug Anderson wrote:
> >>> Previously the dw_mmc driver would ignore any requests to disable the
> >>> card's clock.  This doesn't seem like a good thing in general, but had
> >>> one extra bad side effect in the following situtation:
> >>> * mmc core would set clk to 400kHz at boot time while initting
> >>> * mmc core would set clk to 0 since no card, but it would be ignored.
> >>> * suspend to ram and resume; clocks in the dw_mmc IP block are now 0
> >>>   but dw_mmc thinks that they're 400kHz (it ignored the set to 0).
> >>> * insert card
> >>> * mmc core would set clk to 400kHz which would be considered a no-op.
> >>>
> >>> Note that if there is no card in the slot and we do a suspend/resume
> >>> cycle, we _do_ still end up with differences in a dw_mmc register
> >>> dump, but the differences are clock related and we've got the clock
> >>> disabled both before and after, so this should be OK.
> >>>
> >>> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >>> ---
> >>> Changes in v6:
> >>> - Replaces previous pathes that ensured saving/restoring clocks.
> >>>
> >>>  drivers/mmc/host/dw_mmc.c | 21 +++++++++++----------
> >>>  1 file changed, 11 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> >>> index ee5f167..f6c7545 100644
> >>> --- a/drivers/mmc/host/dw_mmc.c
> >>> +++ b/drivers/mmc/host/dw_mmc.c
> >>> @@ -635,7 +635,11 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
> >>>      u32 div;
> >>>      u32 clk_en_a;
> >>>
> >>> -    if (slot->clock != host->current_speed || force_clkinit) {
> >>> +    if (slot->clock == 0) {
> >>> +            mci_writel(host, CLKENA, 0);
> >>> +            mci_send_cmd(slot,
> >>> +                         SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
> >> Basically dw_mmc driver uses host's low power mode(auto clock gating)
> >> So, how about keeping origin code rather than programming clock setting to '0'?
> > Right, Dw-mmc controller can use the Low-power mode.
> > This mode is functionality like clock-gating. Well, i didn't know what benefit we get, if set to 0.
> 
> Ah, right.  ...so it's unlikely that we'd save any power because we're
> already gating the clock.
> 
> I'd really still rather honor the MMC subsystem's request.  It
> shouldn't _hurt_ to turn the clock off when the subsystem requests it,
Even though turning off by clock programming doesn't hurt, 
it is costly behavior when considering low power mode of host's own support.
Just now, how about focusing on the problem clock isn't updated properly after suspend/resume?

> right?  One reason to honor the mmc core is that it will make things
> cleaner if/when we support a voltage change operation.  The MMC core
> has the logic for the voltage change, and part of that involves
> turning off the clock.  We'll already need a bunch of special case
> code in dw_mmc for voltage change, but it would be nice to avoid one
> extra bit.
Turning off clock during voltage switching would be another procedure.
I guess it could be discussed later.
I want to fix some minor change to prevent frequent message that Jaehoon pointed.

Thanks,
Seungwon Jeon

> 
> Another option would be to add a core MMC quirk to disable MMC_CLKGATE
> on a per-driver basis.  In the "single zImage" world that seems like
> the right thing to do, since the MMC_CLKGATE description seems to
> indicate that enabling that won't really work on all drivers anyway.
> 
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

