Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbaFLJuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:50:00 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63690 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784AbaFLJt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:49:59 -0400
MIME-Version: 1.0
In-Reply-To: <005201cf7e0a$11d1d250$357576f0$%han@samsung.com>
References: <1401345049-14779-1-git-send-email-sachin.kamat@linaro.org>
	<005201cf7e0a$11d1d250$357576f0$%han@samsung.com>
Date: Thu, 12 Jun 2014 15:19:57 +0530
Message-ID: <CAK5sBcGS5w3V7oD0kfTgr2uAFR=joSVS+x3Vi+2Qii7xZJS1yg@mail.gmail.com>
Subject: Re: [PATCH 1/3] phy: exynos-dp-video: Use PTR_ERR_OR_ZERO
From: Sachin Kamat <spk.linux@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On Mon, Jun 2, 2014 at 7:56 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Thursday, May 29, 2014 3:31 PM, Sachin Kamat wrote:
>>
>> PTR_ERR_OR_ZERO simplifies the code.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
>
> Best regards,
> Jingoo Han
>
>> ---
>>  drivers/phy/phy-exynos-dp-video.c |    5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
>> index 0786fef842e7..098f822a2fa4 100644
>> --- a/drivers/phy/phy-exynos-dp-video.c
>> +++ b/drivers/phy/phy-exynos-dp-video.c
>> @@ -9,6 +9,7 @@
>>   * published by the Free Software Foundation.
>>   */
>>
>> +#include <linux/err.h>
>>  #include <linux/io.h>
>>  #include <linux/kernel.h>
>>  #include <linux/module.h>
>> @@ -84,10 +85,8 @@ static int exynos_dp_video_phy_probe(struct platform_device *pdev)
>>       phy_set_drvdata(phy, state);
>>
>>       phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
>> -     if (IS_ERR(phy_provider))
>> -             return PTR_ERR(phy_provider);
>>
>> -     return 0;
>> +     return PTR_ERR_OR_ZERO(phy_provider);
>>  }
>>
>>  static const struct of_device_id exynos_dp_video_phy_of_match[] = {
>> --
>> 1.7.9.5
>
>

ping on this series.

-- 
Regards,
Sachin.
