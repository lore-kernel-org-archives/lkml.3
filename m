Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab3BSMoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:44:54 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38211 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab3BSMox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:44:53 -0500
MIME-Version: 1.0
In-Reply-To: <512363CC.7000401@metafoo.de>
References: <1361217546-3116-1-git-send-email-maxin.john@gmail.com>
	<512363CC.7000401@metafoo.de>
Date: Tue, 19 Feb 2013 13:44:51 +0100
Message-ID: <CAMhs6YwvrPGuZes9Yp+Xpeq7R_PJODU0WVuTjJEZeebNULGjuA@mail.gmail.com>
Subject: Re: [PATCH] dma: timb_dma: Fix compiler warning
From: "Maxin B. John" <maxin.john@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: djbw@fb.com, vinod.koul@intel.com, geert@linux-m68k.org,
        linux-kernel@vger.kernel.org, "Maxin B. John" <maxin.john@enea.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 12:36 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 02/18/2013 08:59 PM, maxin.john@gmail.com wrote:
>> From: "Maxin B. John" <maxin.john@enea.com>
>>
>> Fix this compiler warning:
>> warning: 'td_remove' defined but not used [-Wunused-function]
>>
>> Signed-off-by: Maxin B. John <maxin.john@enea.com>
>> ---
>>  drivers/dma/timb_dma.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
>> index 952f823..f709279 100644
>> --- a/drivers/dma/timb_dma.c
>> +++ b/drivers/dma/timb_dma.c
>> @@ -798,7 +798,7 @@ err_release_region:
>>
>>  }
>>
>> -static int td_remove(struct platform_device *pdev)
>> +static int __exit td_remove(struct platform_device *pdev)
>>  {
>
>>
>
> While this fixes the warning, it's the wrong fix. The correct fix is to
> remove the __exit_p. E.g. something like this:
>
> --- a/drivers/dma/timb_dma.c
> +++ b/drivers/dma/timb_dma.c
> @@ -823,7 +823,7 @@ static struct platform_driver td_driver = {
>                 .owner  = THIS_MODULE,
>         },
>         .probe  = td_probe,
> -       .remove = __exit_p(td_remove),
> +       .remove = td_remove,
>  };
>
>  module_platform_driver(td_driver);

You are right, my bad. I will modify this and send the revised
version soon.

Thanks and Regards,
Maxin
