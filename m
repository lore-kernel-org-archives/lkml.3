Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaG1QGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:06:37 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:53368 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaG1QGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:06:34 -0400
MIME-Version: 1.0
In-Reply-To: <OF27B55084.24F3FB57-ONC1257D23.0054AF74-C1257D23.0058198E@de.ibm.com>
References: <1406010572-13217-1-git-send-email-xerofoify@gmail.com>
	<OF27B55084.24F3FB57-ONC1257D23.0054AF74-C1257D23.0058198E@de.ibm.com>
Date: Mon, 28 Jul 2014 12:06:33 -0400
Message-ID: <CAPDOMVi-Nwv0g6QQM0T1K=kZmtyHf5wkY=Vwo6H_QcDzB9+FPQ@mail.gmail.com>
Subject: Re: [PATCH] s390: Fix me in dasd_eer.c
From: Nick Krause <xerofoify@gmail.com>
To: Stefan Weinhuber <WEIN@de.ibm.com>
Cc: BOEBLINGEN LINUX390 <LINUX390@de.ibm.com>, heicars2@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, mschwid2@linux.vnet.ibm.com,
        Stefan Haberland1 <stefan.haberland@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 12:02 PM, Stefan Weinhuber <WEIN@de.ibm.com> wrote:
> Nicholas Krause <xerofoify@gmail.com> wrote on 2014-07-22 08:29:32:
>
> [..]
>> Subject:
>>
>> [PATCH] s390: Fix me in dasd_eer.c
>>
>> This patch changes return type to EMEDUIMTYPE in function,
> dasd_eer_enable
>> for when checking if the medium has no errors according to this
> function.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  drivers/s390/block/dasd_eer.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/s390/block/dasd_eer.c
> b/drivers/s390/block/dasd_eer.c
>> index 21ef63c..08ee040 100644
>> --- a/drivers/s390/block/dasd_eer.c
>> +++ b/drivers/s390/block/dasd_eer.c
>> @@ -462,7 +462,7 @@ int dasd_eer_enable(struct dasd_device *device)
>>        return 0;
>>
>>     if (!device->discipline || strcmp(device->discipline->name, "ECKD"))
>> -      return -EPERM;   /* FIXME: -EMEDIUMTYPE ? */
>> +      return -EMEDIUMTYPE;   /* FIXME: -EMEDIUMTYPE ? */
>>
>>     cqr = dasd_kmalloc_request(DASD_ECKD_MAGIC, 1 /* SNSS */,
>>                 SNSS_DATA_SIZE, device);
>> --
>> 1.9.1
>>
>
> Hm, after some consideration, I have to disagree with your suggestion.
> If you try to enable EER on an FBA device, you will get the following
> result with current code:
>
> $ echo 1 > eer_enabled
> -bash: echo: write error: Operation not permitted
>
> and with your code the following:
>
> $ echo 1 > eer_enabled
> -bash: echo: write error: Wrong medium type
>
> When I wrote this code, I was not sure which one is better. But today I
> say
> that the 'Operation not permitted' is more to the point. An FBA device
> has no (changable) medium, so what could be wrong about its type?
> Could be confusing.
>
> From your patch description I do not really get why you want to change the
> return code. Why do you think that EMEDIUMTYPE is better than EPERM?
>
> Mit freundlichen Grüßen / Kind regards
>
> Stefan Weinhuber
>
Stefan,
>From my reading seemed more like EMEDUIMTYPE return but seems I was
wrong here. If you want I can remove the fix me message in a patch if you
want to keep this return type.
Regards Nick
