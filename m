Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3DYMvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:51:53 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:32998 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab3DYMvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130425092930.GI4623@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-14-git-send-email-lee.jones@linaro.org>
	<CACRpkdYq9QLRaaysc=izGgi53ogf1oRHuCwWKW+rQBbE_UtfnA@mail.gmail.com>
	<20130425092930.GI4623@gmail.com>
Date: Thu, 25 Apr 2013 14:51:51 +0200
Message-ID: <CACRpkdYywbCeP7wemk2Vy81rm9q3VUbpkN1jUs6UBPLVSOoyHw@mail.gmail.com>
Subject: Re: [PATCH 13/32] dmaengine: ste_dma40: Calculate number of logical
 channels from physical ones
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 11:29 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 25 Apr 2013, Linus Walleij wrote:
>
>> On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > This change will cost ~25KB of memory, but it's worth the trade-off,
>> > as it removes a great deal of overhead. It means that instead of only
>> > allocating memory for the logical channels in use, it does so for all
>> > available ones, which is 32 per physical channel. However, this now
>> > means we can remove some platform data and we don't have to worry
>> > about adding vendor specific variables to Device Tree.
>> >
>> > Cc: Vinod Koul <vinod.koul@intel.com>
>> > Cc: Dan Williams <djbw@fb.com>
>> > Cc: Per Forlin <per.forlin@stericsson.com>
>> > Cc: Rabin Vincent <rabin@rab.in>
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> (...)
>> >  static struct stedma40_platform_data dma40_plat_data = {
>> > -       .dev_len = DB8500_DMA_NR_DEV,
>>
>> So that was set to 64 in the platform...
>>
>> > -       /* Count the number of logical channels in use */
>> > -       for (i = 0; i < plat_data->dev_len; i++)
>> > -               if (plat_data->dev_rx[i] != 0)
>> > -                       num_log_chans++;
>> > -
>> > -       for (i = 0; i < plat_data->dev_len; i++)
>> > -               if (plat_data->dev_tx[i] != 0)
>> > -                       num_log_chans++;
>>
>> And I guess this code snippet made it go down to <= 32 all the time,
>> correct?
>
> However many were described in dma40_[rx|tx]_map, yes.

OK how fragile, but definately not your fault.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
