Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab3BLQxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:53:25 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:40688 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab3BLQxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:53:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130212161604.GO3789@intel.com>
References: <1359471984-26336-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130212161604.GO3789@intel.com>
Date: Tue, 12 Feb 2013 18:53:22 +0200
Message-ID: <CAHp75VdST2ik2Bj3EC0dk_Xmv+=DNdUBOM3KoXvF3iJoWp7t_Q@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: apply default dma_mask if needed
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 6:16 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Tue, Jan 29, 2013 at 05:06:24PM +0200, Andy Shevchenko wrote:
>> In some cases we got the device without dma_mask configured. We have to apply
>> the default value to avoid crashes during memory mapping.
>>
> what was this generated against, it fails to apply for me.

I've tested this against linux-next. The problem apparently in the
patch which Greg submits earlier:
7331205a "dma: Convert to devm_ioremap_resource()". If you want I
could rebase it against your next branch. I thought you'd seen that
patch already.

>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> ---
>>  drivers/dma/dw_dmac.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>> index e8d0679..a572a1e 100644
>> --- a/drivers/dma/dw_dmac.c
>> +++ b/drivers/dma/dw_dmac.c
>> @@ -1673,6 +1673,12 @@ static int dw_probe(struct platform_device *pdev)
>>       if (IS_ERR(regs))
>>               return PTR_ERR(regs);
>>
>> +     /* Apply default dma_mask if needed */
>> +     if (!pdev->dev.dma_mask) {
>> +             pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
>> +             pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>> +     }
>> +
>>       dw_params = dma_read_byaddr(regs, DW_PARAMS);
>>       autocfg = dw_params >> DW_PARAMS_EN & 0x1;
>>
>> --
>> 1.7.10.4
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
