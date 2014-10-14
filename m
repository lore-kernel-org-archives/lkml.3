Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaJNQvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:51:31 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:38999 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbaJNQv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:51:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=VQe-9c+QOYEmsuHwY+9qF1tkTgiakdSUWhUoWw6zuHSA@mail.gmail.com>
References: <1412618020-22278-1-git-send-email-sonnyrao@chromium.org>
	<CAGOxZ53bviLbuA27=1QjNUgxA_WMMP-6siV=DajuN8iSqsasMg@mail.gmail.com>
	<CAO3aYcqi0g=eJta33s5oM-tAAmAhe86VvHd43p5RJ7qMPZzfrg@mail.gmail.com>
	<CAGOxZ520EXdS9FoCVW7GPvheNSZu=xqc2makJY5D0c3zjVBkDw@mail.gmail.com>
	<CAD=FV=VQe-9c+QOYEmsuHwY+9qF1tkTgiakdSUWhUoWw6zuHSA@mail.gmail.com>
Date: Tue, 14 Oct 2014 09:51:26 -0700
X-Google-Sender-Auth: ZsbAcs56yyOuBKqEuWkppdwF_iM
Message-ID: <CAD=FV=W57417Jdp8d-=yZgjUdTJyMKnzSvwg6YuXz3eTvTZZuQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Reset DMA before enabling IDMAC
From: Doug Anderson <dianders@chromium.org>
To: Alim Akhtar <alim.akhtar@gmail.com>
Cc: =?UTF-8?B?RWRkaWUgQ2FpKOiUoeaeqyk=?= <eddie.cai@rock-chips.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Addy Ke <addy.ke@rock-chips.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 9, 2014 at 5:36 PM, Doug Anderson <dianders@chromium.org> wrote:
> Alim,
>
> On Thu, Oct 9, 2014 at 3:19 PM, Alim Akhtar <alim.akhtar@gmail.com> wrote:
>> Thats fine, I think every vendor (most of them) has a custom
>> implementation of dw_mmc, but they do have VERID register to check the
>> dw_mmc version.
>> The reason why I asked is, I have seen inconsistency in card
>> enumeration on few controller version, and this patch alone does not
>> help, and adding a call to dw_mci_idmac_reset() after DMA reset is
>> needed. And this is what is recommended in the synopsys's data book
>> also.
>> Do you see any issue/side effect after adding dw_mci_idmac_reset()?
>
> A quick test shows no problem with adding this to Sonny's patch:
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 66dc8fe..588b5b8 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -481,6 +481,7 @@ static void dw_mci_idmac_start_dma(struct dw_mci
> *host, unsigned int sg_len)
>
>         /* Make sure to reset DMA in case we did PIO before this */
>         dw_mci_ctrl_reset(host, SDMMC_CTRL_DMA_RESET);
> +       dw_mci_idmac_reset(host);
>
>         /* Select IDMAC interface */
>         temp = mci_readl(host, CTRL);
>
> I'll start reboot tests now to see how it behaves...  I think Sonny is
> out of the office for a few days so we might need to wait for a spin,
> but I'll run with that change in the meantime and see how it behaves
> for me.
>
> Thanks!

Just FYI that I've been running with Alim's proposed change for
several days and it seems solid.  I think Sonny may be able to spin
his patch this week.  :)

-Doug
