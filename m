Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaG2Vft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 17:35:49 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36728 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaG2Vfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 17:35:48 -0400
MIME-Version: 1.0
In-Reply-To: <53D65D53.8000602@linux.vnet.ibm.com>
References: <1406385418-3393-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <53D65D53.8000602@linux.vnet.ibm.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Tue, 29 Jul 2014 23:35:27 +0200
Message-ID: <CAFo99gY-L+jDCLWw=DusJFowpmFj1unAqspNku5J3g-SgbHUdA@mail.gmail.com>
Subject: Re: [PATCH] s390: scsi: zfcp_aux.c: Cleaning up missing
 null-terminate in conjunction with strncpy
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-28 16:25 GMT+02:00 Steffen Maier <maier@linux.vnet.ibm.com>:
> On 07/26/2014 04:36 PM, Rickard Strandqvist wrote:
>>
>> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>>
>> Signed-off-by: Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se>
>> ---
>>   drivers/s390/scsi/zfcp_aux.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
>> index 8004b07..a23ba76 100644
>> --- a/drivers/s390/scsi/zfcp_aux.c
>> +++ b/drivers/s390/scsi/zfcp_aux.c
>> @@ -101,7 +101,7 @@ static void __init zfcp_init_device_setup(char
>> *devstr)
>>         token = strsep(&str, ",");
>>         if (!token || strlen(token) >= ZFCP_BUS_ID_SIZE)
>>                 goto err_out;
>
>
> Due to the check for strlen(token) >= ZFCP_BUS_ID_SIZE we should be safe
> even with strlcpy because we would reject any user string that does not fit
> into busid including the trailing zero character.
>
> Since it works either way, we can change it though,
>
> Acked-by: Steffen Maier <maier@linux.vnet.ibm.com>
>
>
>> -       strncpy(busid, token, ZFCP_BUS_ID_SIZE);
>> +       strlcpy(busid, token, ZFCP_BUS_ID_SIZE);
>>
>>         token = strsep(&str, ",");
>>         if (!token || kstrtoull(token, 0, (unsigned long long *) &wwpn))
>>

Hi

Always fun to get a patch included :)

It would be possible to change it to:

    if (!token || strlcpy(busid, token, ZFCP_BUS_ID_SIZE) >= ZFCP_BUS_ID_SIZE)
        goto err_out;


But I doubt if this does not degrade the clarity quite a lot however :-/

But tell me otherwise if you want a patch like that instead :-)


Kind regards
Rickard Strandqvist
