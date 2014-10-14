Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbaJNT6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:58:44 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:47987 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbaJNT6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:58:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=W57417Jdp8d-=yZgjUdTJyMKnzSvwg6YuXz3eTvTZZuQ@mail.gmail.com>
References: <1412618020-22278-1-git-send-email-sonnyrao@chromium.org>
 <CAGOxZ53bviLbuA27=1QjNUgxA_WMMP-6siV=DajuN8iSqsasMg@mail.gmail.com>
 <CAO3aYcqi0g=eJta33s5oM-tAAmAhe86VvHd43p5RJ7qMPZzfrg@mail.gmail.com>
 <CAGOxZ520EXdS9FoCVW7GPvheNSZu=xqc2makJY5D0c3zjVBkDw@mail.gmail.com>
 <CAD=FV=VQe-9c+QOYEmsuHwY+9qF1tkTgiakdSUWhUoWw6zuHSA@mail.gmail.com> <CAD=FV=W57417Jdp8d-=yZgjUdTJyMKnzSvwg6YuXz3eTvTZZuQ@mail.gmail.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Wed, 15 Oct 2014 01:28:01 +0530
Message-ID: <CAGOxZ52an-GUiHadN9Xp29L_WvPH4pS2LSz7BbsQrm7qLXjzQw@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Reset DMA before enabling IDMAC
To: Doug Anderson <dianders@chromium.org>
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

Hi Doug,

On Tue, Oct 14, 2014 at 10:21 PM, Doug Anderson <dianders@chromium.org> wrote:
> Hi,
>
> On Thu, Oct 9, 2014 at 5:36 PM, Doug Anderson <dianders@chromium.org> wrote:
>> Alim,
>>
>> On Thu, Oct 9, 2014 at 3:19 PM, Alim Akhtar <alim.akhtar@gmail.com> wrote:
>>> Thats fine, I think every vendor (most of them) has a custom
>>> implementation of dw_mmc, but they do have VERID register to check the
>>> dw_mmc version.
>>> The reason why I asked is, I have seen inconsistency in card
>>> enumeration on few controller version, and this patch alone does not
>>> help, and adding a call to dw_mci_idmac_reset() after DMA reset is
>>> needed. And this is what is recommended in the synopsys's data book
>>> also.
>>> Do you see any issue/side effect after adding dw_mci_idmac_reset()?
>>
>> A quick test shows no problem with adding this to Sonny's patch:
>>
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index 66dc8fe..588b5b8 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -481,6 +481,7 @@ static void dw_mci_idmac_start_dma(struct dw_mci
>> *host, unsigned int sg_len)
>>
>>         /* Make sure to reset DMA in case we did PIO before this */
>>         dw_mci_ctrl_reset(host, SDMMC_CTRL_DMA_RESET);
>> +       dw_mci_idmac_reset(host);
>>
>>         /* Select IDMAC interface */
>>         temp = mci_readl(host, CTRL);
>>
>> I'll start reboot tests now to see how it behaves...  I think Sonny is
>> out of the office for a few days so we might need to wait for a spin,
>> but I'll run with that change in the meantime and see how it behaves
>> for me.
>>
>> Thanks!
>
> Just FYI that I've been running with Alim's proposed change for
> several days and it seems solid.  I think Sonny may be able to spin
> his patch this week.  :)
>
Sounds great. Thanks for testing.
> -Doug



-- 
Regards,
Alim
