Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaDVNFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:05:10 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:54495 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaDVNFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:05:05 -0400
MIME-Version: 1.0
In-Reply-To: <000901cf5e26$e1005fa0$a3011ee0$%jun@samsung.com>
References: <000c01cf5df8$1fecf810$5fc6e830$%jun@samsung.com>
	<CAPDyKFoMOJ_Eb3O5B-Sy-fF0Yx7Mp==3-Wyff=rTVNCO3YxCFg@mail.gmail.com>
	<000801cf5e19$07613c40$1623b4c0$%jun@samsung.com>
	<CAPDyKFpe4_3BXFB8jxHhZknfmT2UrO6ddCcOpq2whN3ayEO6Dg@mail.gmail.com>
	<000901cf5e26$e1005fa0$a3011ee0$%jun@samsung.com>
Date: Tue, 22 Apr 2014 15:05:03 +0200
Message-ID: <CAPDyKFr6t-FJSahK-U+a-09hYG-GxxY2=xCJZkPtNysGfcT2eA@mail.gmail.com>
Subject: Re: [PATCH] linux-next: rsi: fix using of removed stuff from mmc
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Fariya Fatima <fariyaf@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >>
>> >> I am not sure it's safe to carry this patch through Chris' mmc tree
>> >> due to merge conflicts with John's wireless tree.
>> >>
>> >> Though, since you have changed the mmc_card_highspeed() function to be
>> >> named to mmc_card_hs(), we need to work out the dependency.
>> >>
>> >> We have some options to handle this, I suggest the following.
>> >>
>> >> Re-spin this patch to keep using mmc_card_highspeed() and let John
>> >> take it through his wireless tree. Thus  you also need to keep the
>> > It would be better if this patch can be handled in Chris's.
>> > Because if the rest of changes of this patch with keeping "mmc_card_highspeed" is applied,
>> > high-speed SDIO will be ignored in John's tree.
>>
>> You are right Seungwon!
>>
>> Please re-spin the patchset on the mmc core an squash the code from
>> this patch, into the patch "mmc: drop the speed mode of card's state".
>> We then need to get acks from John and Fariya.
> Sure! I'll send before long.
> You still want to get back naming for mmc_card_highspeed?

It's up to you, I have no strong opinion.

Kind regards
Ulf Hansson

>
>>
>> BTW, I had a look at the rsi_reset_card() function
>> (drivers/net/wireless/rsi/rsi_91x_sdio.c), which handles a complete
>> SDIO re-initialization and I think performs "layering violations"
>> while doing that.  I suppose it's because of lack of documentation
>> about the mmc/sdio core, but I really don't think an SDIO func driver
>> should be doing that kind of stuff by itself. There are APIs to use to
>> perform an SDIO reset. Two options exists:
>>
>> a) Use pm_runtime_get|put in combination with a MMC_CAP_POWER_OFF_CARD
>> enabled host.
>> b) Invoke mmc_power_save|restore_host() API.
> Yes, we could expect better changes in rsi sdio soon.
>
> Thanks,
> Seungwon Jeon
>>
>> Kind regards
>> Ulf Hansson
>>
>> >
>> > Thanks,
>> > Seungwon Jeon
>> >
>> >> name mmc_card_highspeed() function from the patches to the mmc core -
>> >> could you please re-spin and post new version of those patches as
>> >> well!?
>> >>
>> >> Kind regards
>> >> Ulf Hansson
>> >
>
