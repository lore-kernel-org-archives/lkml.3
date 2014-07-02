Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaGBIoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:44:20 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:48372 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaGBIoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:44:17 -0400
MIME-Version: 1.0
In-Reply-To: <53997989.5050406@ti.com>
References: <1401345049-14779-1-git-send-email-sachin.kamat@linaro.org>
	<005201cf7e0a$11d1d250$357576f0$%han@samsung.com>
	<CAK5sBcGS5w3V7oD0kfTgr2uAFR=joSVS+x3Vi+2Qii7xZJS1yg@mail.gmail.com>
	<53997989.5050406@ti.com>
Date: Wed, 2 Jul 2014 14:14:15 +0530
Message-ID: <CAK5sBcH-bOMyqGJhsKxNG6VK02sQ97eJ88iQRjBZOp7i_D6bsA@mail.gmail.com>
Subject: Re: [PATCH 1/3] phy: exynos-dp-video: Use PTR_ERR_OR_ZERO
From: Sachin Kamat <spk.linux@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 3:27 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>
>
> On Thursday 12 June 2014 03:19 PM, Sachin Kamat wrote:
>> Hi Kishon,
>>
>> On Mon, Jun 2, 2014 at 7:56 AM, Jingoo Han <jg1.han@samsung.com> wrote:
>>> On Thursday, May 29, 2014 3:31 PM, Sachin Kamat wrote:
>>>>
>>>> PTR_ERR_OR_ZERO simplifies the code.
>>>>
>>>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>>>> Cc: Jingoo Han <jg1.han@samsung.com>
>>>
>>> Acked-by: Jingoo Han <jg1.han@samsung.com>
>>>
>>> Best regards,
>>> Jingoo Han
>>>
>>>> ---
>>>>  drivers/phy/phy-exynos-dp-video.c |    5 ++---
>>>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
>>>> index 0786fef842e7..098f822a2fa4 100644
>>>> --- a/drivers/phy/phy-exynos-dp-video.c
>>>> +++ b/drivers/phy/phy-exynos-dp-video.c
>>>> @@ -9,6 +9,7 @@
>>>>   * published by the Free Software Foundation.
>>>>   */
>>>>
>>>> +#include <linux/err.h>
>>>>  #include <linux/io.h>
>>>>  #include <linux/kernel.h>
>>>>  #include <linux/module.h>
>>>> @@ -84,10 +85,8 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
>>>>       phy_set_drvdata(phy, state);
>>>>
>>>>       phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
>>>> -     if (IS_ERR(phy_provider))
>>>> -             return PTR_ERR(phy_provider);
>>>>
>>>> -     return 0;
>>>> +     return PTR_ERR_OR_ZERO(phy_provider);
>>>>  }
>>>>
>>>>  static const struct of_device_id exynos_dp_video_phy_of_match[] = {
>>>> --
>>>> 1.7.9.5
>>>
>>>
>>
>> ping on this series.
>
> I'll queue to -next once -rc1 is tagged.

Gentle ping..


-- 
Regards,
Sachin.
