Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057Ab3GEPQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:16:25 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38721 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964960Ab3GEPQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <51D24318.40908@atmel.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
 <1372667978-4718-3-git-send-email-richard.genoud@gmail.com> <51D24318.40908@atmel.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 5 Jul 2013 17:16:03 +0200
Message-ID: <CACQ1gAj9bY9Tw2-Ps7-Bm2-gS0PY=hocRPvXCQhmcQ9-sKg1kQ@mail.gmail.com>
Subject: Re: [RFC PATCH 02/13] misc: atmel_ssc: keep the count of pdev->id
To: Bo Shen <voice.shen@atmel.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/2 Bo Shen <voice.shen@atmel.com>:
> Hi Richard,
>
>
> On 7/1/2013 16:39, Richard Genoud wrote:
>>
>> With device tree, pdev->id is always -1, so we introduce a local
>> counter.
>>
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>> ---
>>   drivers/misc/atmel-ssc.c |    7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
>> index 3afbd82..d1ec5ab 100644
>> --- a/drivers/misc/atmel-ssc.c
>> +++ b/drivers/misc/atmel-ssc.c
>> @@ -173,6 +173,12 @@ out:
>>         return err;
>>   }
>>
>> +/* counter of ssc devive instances.
>> + * With device tree pdev->id is always -1, so we have to keep the
>> + * count ourselves
>> + */
>> +static int ssc_device_id;
>
>
> Do we really need this? If Yes, would it better to get from device through
> of_alias_get_id?

you're right, it seems that we don't need that anymore.

thanks !

Richard.
