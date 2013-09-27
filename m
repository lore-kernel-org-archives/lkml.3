Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3I0JEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 05:04:53 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56452 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3I0JEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 05:04:48 -0400
MIME-Version: 1.0
In-Reply-To: <CANEJEGuGWKVudcKMrZKLPEMEpQ5sJFJn4xwOOe7N6q9_qfy3bw@mail.gmail.com>
References: <1379611214-1089-1-git-send-email-grundler@chromium.org>
	<CAPDyKFr0h=uTz4xOAULLc0Ff23xB-xVuuk+XnBz_Uq5YMryHbA@mail.gmail.com>
	<87fvss2uh9.fsf@octavius.laptop.org>
	<8738os2tqt.fsf@octavius.laptop.org>
	<CANEJEGt9E3apwKMpLFL8_5cy8GW9EdcNgXtm-XGAmQWgYftVjw@mail.gmail.com>
	<CANEJEGuGWKVudcKMrZKLPEMEpQ5sJFJn4xwOOe7N6q9_qfy3bw@mail.gmail.com>
Date: Fri, 27 Sep 2013 11:04:47 +0200
Message-ID: <CAPDyKFp8G_F65u_eGam99DTDckzoKx2oct18Jo7zm54U8jY7=Q@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: remove issue_fn indirect function call
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Grant Grundler <grundler@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 September 2013 00:16, Grant Grundler <grundler@chromium.org> wrote:
> On Thu, Sep 26, 2013 at 2:56 PM, Grant Grundler <grundler@chromium.org> wrote:
>> On Wed, Sep 25, 2013 at 7:37 PM, Chris Ball <cjb@laptop.org> wrote:
>>> Hi,
>>>
>>> On Wed, Sep 25 2013, Chris Ball wrote:
>>>> Hi,
>>>>
>>>> On Fri, Sep 20 2013, Ulf Hansson wrote:
>>>>> On 19 September 2013 19:20, Grant Grundler <grundler@chromium.org> wrote:
>>>>>> struct mmc_queue defines issue_fn as an indirect function call.
>>>>>> issue_fn field only gets set to mmc_blk_issue_rq and only gets
>>>>>> invoked immediately after calling blk_fetch_request().
>>>>>> Don't bother with indirect function call - it's pointless and just
>>>>>> obfuscates the code.
>>>>>>
>>>>>> Signed-off-by: Grant Grundler <grundler@chromium.org>
>>>>>
>>>>> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>>>>
>>>> Thanks, pushed to mmc-next for 3.13.
>>>
>>> Have dropped this, it's breaking my build:
>>>
>>> /home/cjb/git/mmc/drivers/mmc/card/block.c:1955:12: warning: ‘mmc_blk_issue_rq’ defined but not used [-Wunused-function]
>>
>> The function is declared static. :(  Let me respin to remove the
>> static and add a function prototype to a header file.
>
> block.o and queue.o are linked together into one .ko all the time:
> obj-$(CONFIG_MMC_BLOCK)         += mmc_block.o
> mmc_block-objs                  := block.o queue.o
>
> Two ways to handle this: I can
> 1) add a local function prototype of mmc_blk_issue_rq() to queue.c
> 2) move mmc_init_queue() and mmc_queue_thread() from queue.c to block.c
>
> (2) actually makes sense since both functions are block IO specific.
>
> Thoughts? Preference? Other ideas?

Hi Grant,

Generally I am in favour of cleaning up messy code. But in this case
it now seems a bit overworked.

How about actually leaving it as is?

Kind regards
Ulf Hansson

>
> thanks,
> grant
>
> ps. It's more obvious now that the return value from
> mmc_blk_issue_rq() is getting ignored. *sigh*
