Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbaCFHTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:19:21 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:41888 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaCFHTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:19:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140305101320.GH1883@distanz.ch>
References: <4401309.KAOCJ1Tfb2@daeseok-laptop.cloud.net>
	<20140305101320.GH1883@distanz.ch>
Date: Thu, 6 Mar 2014 16:19:19 +0900
Message-ID: <CAHb8M2C54=bWAE7T0OrTmx2hr4dRiW1R29YgLXRdOfpSioNV-w@mail.gmail.com>
Subject: Re: [PATCH 7/7] staging: cxt1e1: remove unneeded a value
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel <devel@driverdev.osuosl.org>,
        Shaun Laing <shaun@xresource.ca>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        "ying.xue" <ying.xue@windriver.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-05 19:13 GMT+09:00 Tobias Klauser <tklauser@distanz.ch>:
> On 2014-03-05 at 02:24:22 +0100, Daeseok Youn <daeseok.youn@gmail.com> wrote:
>>
>> It doesn't need to assign name array address to np pointer.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/cxt1e1/linux.c |    5 ++---
>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
>> index 5bb42ae..cae8c66 100644
>> --- a/drivers/staging/cxt1e1/linux.c
>> +++ b/drivers/staging/cxt1e1/linux.c
>> @@ -205,15 +205,14 @@ status_t
>>  c4_wq_port_init(mpi_t *pi)
>>  {
>>
>> -     char        name[16], *np;  /* NOTE: name of the queue limited by system
>> +     char        name[16];  /* NOTE: name of the queue limited by system
>>                                    * to 10 characters */
>>
>>       if (pi->wq_port)
>>               return 0;                   /* already initialized */
>>
>> -     np = name;
>>       memset(name, 0, 16);
>
> This isn't necessary since s{,n}printf() adds a terminating '\0'.
Yes, I have looked at lib/vsprintf.c. I found it adds null to a string
in the end of vsnprintf() function.
I will remove memset() line.

>
>> -     sprintf(np, "%s%d", pi->up->devname, pi->portnum); /* IE pmcc4-01) */
>> +     sprintf(name, "%s%d", pi->up->devname, pi->portnum); /* IE pmcc4-01) */
>
> Better use snprintf() here, even if the comment above claims the name
> never to be no longer than 10 characters.
OK. I will replace sprintf with snprintf() and set a string length to "10".

Thanks for review.
Daeseok Youn.
>
> Cheers
> Tobias
