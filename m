Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823Ab3CNQlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:41:22 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:61020 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590Ab3CNQlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:41:19 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1303141424390.22728@axis700.grange>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <1363266691-15757-2-git-send-email-fabio.porcedda@gmail.com> <Pine.LNX.4.64.1303141424390.22728@axis700.grange>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Thu, 14 Mar 2013 17:40:58 +0100
Message-ID: <CAHkwnC8cGMi83wTWG8C7kOdhHB3O-ZktzmU12qw3f9cTxTYvrg@mail.gmail.com>
Subject: Re: [PATCH 01/10] drivers: media: use module_platform_driver_probe()
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Josh Wu <josh.wu@atmel.com>, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 2:25 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Fabio
>
> On Thu, 14 Mar 2013, Fabio Porcedda wrote:
>
>> This patch converts the drivers to use the
>> module_platform_driver_probe() macro which makes the code smaller and
>> a bit simpler.
>>
>> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Josh Wu <josh.wu@atmel.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: linux-media@vger.kernel.org
>
> Thanks for the patch. Subtracting this series
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/61403
> you only need to convert atmel-isi.c. Please, respin.

Ok, I'll send a updated one.

Thanks for the reviewing the patch.

Best regards
Fabio Porcedda

> Thanks
> Guennadi
>
>> ---
>>  drivers/media/platform/sh_vou.c                | 13 +------------
>>  drivers/media/platform/soc_camera/atmel-isi.c  | 12 +-----------
>>  drivers/media/platform/soc_camera/mx1_camera.c | 13 +------------
>>  3 files changed, 3 insertions(+), 35 deletions(-)
>>
>> diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
>> index 66c8da1..d853162 100644
>> --- a/drivers/media/platform/sh_vou.c
>> +++ b/drivers/media/platform/sh_vou.c
>> @@ -1485,18 +1485,7 @@ static struct platform_driver __refdata sh_vou = {
>>       },
>>  };
>>
>> -static int __init sh_vou_init(void)
>> -{
>> -     return platform_driver_probe(&sh_vou, sh_vou_probe);
>> -}
>> -
>> -static void __exit sh_vou_exit(void)
>> -{
>> -     platform_driver_unregister(&sh_vou);
>> -}
>> -
>> -module_init(sh_vou_init);
>> -module_exit(sh_vou_exit);
>> +module_platform_driver_probe(sh_vou, sh_vou_probe);
>>
>>  MODULE_DESCRIPTION("SuperH VOU driver");
>>  MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
>> index 82dbf99..12ba31d 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>> @@ -1081,17 +1081,7 @@ static struct platform_driver atmel_isi_driver = {
>>       },
>>  };
>>
>> -static int __init atmel_isi_init_module(void)
>> -{
>> -     return  platform_driver_probe(&atmel_isi_driver, &atmel_isi_probe);
>> -}
>> -
>> -static void __exit atmel_isi_exit(void)
>> -{
>> -     platform_driver_unregister(&atmel_isi_driver);
>> -}
>> -module_init(atmel_isi_init_module);
>> -module_exit(atmel_isi_exit);
>> +module_platform_driver_probe(atmel_isi_driver, atmel_isi_probe);
>>
>>  MODULE_AUTHOR("Josh Wu <josh.wu@atmel.com>");
>>  MODULE_DESCRIPTION("The V4L2 driver for Atmel Linux");
>> diff --git a/drivers/media/platform/soc_camera/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
>> index 25b2a28..4389f43 100644
>> --- a/drivers/media/platform/soc_camera/mx1_camera.c
>> +++ b/drivers/media/platform/soc_camera/mx1_camera.c
>> @@ -859,18 +859,7 @@ static struct platform_driver mx1_camera_driver = {
>>       .remove         = __exit_p(mx1_camera_remove),
>>  };
>>
>> -static int __init mx1_camera_init(void)
>> -{
>> -     return platform_driver_probe(&mx1_camera_driver, mx1_camera_probe);
>> -}
>> -
>> -static void __exit mx1_camera_exit(void)
>> -{
>> -     return platform_driver_unregister(&mx1_camera_driver);
>> -}
>> -
>> -module_init(mx1_camera_init);
>> -module_exit(mx1_camera_exit);
>> +module_platform_driver_probe(mx1_camera_driver, mx1_camera_probe);
>>
>>  MODULE_DESCRIPTION("i.MX1/i.MXL SoC Camera Host driver");
>>  MODULE_AUTHOR("Paulius Zaleckas <paulius.zaleckas@teltonika.lt>");
>> --
>> 1.8.1.5
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/



-- 
Fabio Porcedda
