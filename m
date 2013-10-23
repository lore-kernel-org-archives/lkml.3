Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3JWLZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:25:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46370 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3JWLZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:25:38 -0400
X-AuditID: cbfee68f-b7f836d000001b39-25-5267b230a5c6
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>
Cc: "'Chris Ball'" <cjb@laptop.org>, "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Sonny Rao'" <sonnyrao@chromium.org>,
        "'Bing Zhao'" <bzhao@marvell.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1381876762-10892-1-git-send-email-dianders@chromium.org>
 <1381876762-10892-2-git-send-email-dianders@chromium.org>
 <52610273.3080005@samsung.com>
 <CAD=FV=UiUxoqbAeq+3iUChqksHd_NpJs2rM83=ng3fprMj0E-A@mail.gmail.com>
In-reply-to: <CAD=FV=UiUxoqbAeq+3iUChqksHd_NpJs2rM83=ng3fprMj0E-A@mail.gmail.com>
Subject: RE: [PATCH 1/2] mmc: dw_mmc: Cleanup disable of low power mode w/ SDIO
 interrupts
Date: Wed, 23 Oct 2013 20:25:36 +0900
Message-id: <001701cecfe2$9831eb90$c895c2b0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7MPf2Y+J50eQ7eTpivjLSA9lI0pQDoH2oQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zoa7BpvQgg20NahaP1yxmsngwbxub
	xbytR1kttr/eyGZxdtlBNotXR34wWbyb94LZ4savNlaLy7vmsFkc+d/PaHHq+mc2iydnZjJa
	rNr1h9GB12N2w0UWj52z7rJ79Ow8w+hx6MpaRo8rJ5pYPSYvvMjs0bdlFaPH501yARxRXDYp
	qTmZZalF+nYJXBnr//ayF7SLVlzZdpitgXEGfxcjJ4eEgInEp0W3mSBsMYkL99azgdhCAssY
	JTZ+8oepOT/zLVCcCyi+iFHi/t82JgjnD6NEy/0p7CBVbAJaEn/fvGHuYuTgEBEIl9h7UwWk
	hllgLrPE4/kfWCAaXjJKrNr8jRWkiFMgWGJ2uwNIr7BAjMT3C48ZQWwWAVWJXbN/sILYvAK2
	Eqe77jJC2IISPybfYwGxmQX0JD7+uc0IYctLbF7zFmyvhIC6xKO/uiBhEQEjiUmv+1ghSkQk
	9r14xwhygoTADg6Jpi8f2SF2CUh8m3yIBaJXVmLTAWaIhyUlDq64wTKBUWIWks2zkGyehWTz
	LCQrFjCyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQISQv9OxjvHrA+xJgMtH4is5Rocj4w
	reSVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsYN
	CSa3OZQafW3lOvKVr28z8vQIEXp7cJ6U48RVe5tq9CSMj8z/yVIv3Sp2de6vwOM7Ll/73ni+
	/8yizzdun35+PMOXZbHX5g/XY+I4NKd8fCMufPXH8zLZqy2c/9O3cGby3jkkUr299JBWxYVg
	zfm/OG7k23cHrPqwsGZWugVjxs0bW5JvzXurxFKckWioxVxUnAgAiM7maSEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t9jAV2DTelBBu1nFCwer1nMZPFg3jY2
	i3lbj7JabH+9kc3i7LKDbBavjvxgsng37wWzxY1fbawWl3fNYbM48r+f0eLU9c9sFk/OzGS0
	WLXrD6MDr8fshossHjtn3WX36Nl5htHj0JW1jB5XTjSxekxeeJHZo2/LKkaPz5vkAjiiGhht
	MlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVlIoS8wp
	BQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmrP/by17QLlpxZdthtgbGGfxdjJwc
	EgImEudnvmWDsMUkLtxbD2RzcQgJLGKUuP+3jQnC+cMo0XJ/CjtIFZuAlsTfN2+Yuxg5OEQE
	wiX23lQBqWEWmMss8Xj+BxaIhpeMEqs2f2MFKeIUCJaY3e4A0issECPx/cJjRhCbRUBVYtfs
	H6wgNq+ArcTprruMELagxI/J91hAbGYBPYmPf24zQtjyEpvXvAXbKyGgLvHory5IWETASGLS
	6z5WiBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5
	uZsYwWnnmdQOxpUNFocYBTgYlXh4LdrTgoRYE8uKK3MPMUpwMCuJ8K6fnR4kxJuSWFmVWpQf
	X1Sak1p8iDEZ6NGJzFKiyfnAlJhXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTU
	gtQimC1MHJxSDYwFcyX+u238ydjYaXns16nLHgHnIsQNNvy898PI46Qg1w1GBRGv5jubu9Uv
	iZ+SyffutzM8ynlxn8a1v0JbE5YfUiv/cSTH3OEpY84/1Z/X5SarmhUKXqoLmTzlROQjK7O3
	e797fuGd9vqt1NcJ0t+1t+p+2fNv9eYZymeCA/JiZ9rGnJqwTjtDiaU4I9FQi7moOBEAOgFv
	BX8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

This change looks good.
There's comment below.

On Sat, October 19, 2013, Doug Anderson wrote:
> Jaehoon,
> 
> On Fri, Oct 18, 2013 at 2:42 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> >> -     clk_en_a = mci_readl(host, CLKENA);
> >> +     /*
> >> +      * Low power mode will stop the card clock when idle.  According to the
> >> +      * description of the CLKENA register we should disable low power mode
> >> +      * for SDIO cards if we need SDIO interrupts to work.
> >> +      */
> >> +     if (mmc->caps | MMC_CAP_SDIO_IRQ) {
> > mmc->caps & MMC_CAP_SDIO_IRQ?
> 
> Wow, that was an embarrassing one.  Thanks.
> 
> >> +             const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
> >> +             u32 clk_en_a_old;
> >> +             u32 clk_en_a;
> >>
> >> -     if (clk_en_a & clken_low_pwr) {
> >> -             mci_writel(host, CLKENA, clk_en_a & ~clken_low_pwr);
> >> -             mci_send_cmd(slot, SDMMC_CMD_UPD_CLK |
> >> -                          SDMMC_CMD_PRV_DAT_WAIT, 0);
> >> +             clk_en_a_old = mci_readl(host, CLKENA);
> >> +
> >> +             if (card->type == MMC_TYPE_SDIO ||
> >> +                 card->type == MMC_TYPE_SD_COMBO) {
&& card->quirks & MMC_QUIRK_BROKEN_CLK_GATING
How about considering MMC_QUIRK_BROKEN_CLK_GATING?
Some sdio device can work with gating clock.
For this, mmc_fixup_device() should be called prior to init_card() in core(sdio.c).
I guess you found that.

Thanks,
Seungwon Jeon

> >> +                     set_bit(DW_MMC_CARD_NO_LOW_PWR, &slot->flags);
> >> +                     clk_en_a = clk_en_a_old & ~clken_low_pwr;
> >> +             } else {
> >> +                     clear_bit(DW_MMC_CARD_NO_LOW_PWR, &slot->flags);
> >> +                     clk_en_a = clk_en_a_old | clken_low_pwr;
> > When this condition is entered? card->type is always MMC_TYPE_SDIO or MMC_TYPE_SD_COMBO, isn't?
> 
> Ugh, that's not intuitive.  This callback is only called for SDIO
> cards and not MMC/SD cards?  That means if you plug in an SDIO card
> and then eject it and plug in an SD card you won't get to low power.
> Hrm.
> 
> I dug around a bit and couldn't find a better way to do this and then
> I realized that the other user of the init_card() callback has the
> same bug, so for the next version of the series I'm proposing a fix
> for mmc core to add this for all types.  If you have a better
> suggestion, I'm all ears.
> 
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

