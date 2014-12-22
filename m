Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaLVWw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:52:26 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63831 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaLVWwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:52:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAHtARFFmUJ5_mnJu=yLb8bGXcMNza8oHsThHPb3_QgE-pq4BGg@mail.gmail.com>
References: <1406473878-12715-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <CAHtARFFmUJ5_mnJu=yLb8bGXcMNza8oHsThHPb3_QgE-pq4BGg@mail.gmail.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 22 Dec 2014 23:52:02 +0100
Message-ID: <CAFo99gaY5MQ2uDWOGkQgJxseNorv0NRNY3PVJg395gqHtkKrjg@mail.gmail.com>
Subject: Re: [PATCH] scsi: 3w-9xxx.c: Cleaning up missing null-terminate in
 conjunction with strncpy
To: adam radford <aradford@gmail.com>
Cc: Adam Radford <linuxraid@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-01 0:19 GMT+02:00 adam radford <aradford@gmail.com>:
> On Sun, Jul 27, 2014 at 8:11 AM, Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se> wrote:
>> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>> And use the sizeof on the to string rather than strlen on the from string.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/scsi/3w-9xxx.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
>> index 0a73253..f4d2331 100644
>> --- a/drivers/scsi/3w-9xxx.c
>> +++ b/drivers/scsi/3w-9xxx.c
>> @@ -621,7 +621,8 @@ static int twa_check_srl(TW_Device_Extension *tw_dev, int *flashed)
>>         }
>>
>>         /* Load rest of compatibility struct */
>> -       strncpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION, strlen(TW_DRIVER_VERSION));
>> +       strlcpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION,
>> +               sizeof(tw_dev->tw_compat_info.driver_version));
>>         tw_dev->tw_compat_info.driver_srl_high = TW_CURRENT_DRIVER_SRL;
>>         tw_dev->tw_compat_info.driver_branch_high = TW_CURRENT_DRIVER_BRANCH;
>>         tw_dev->tw_compat_info.driver_build_high = TW_CURRENT_DRIVER_BUILD;
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> Rickard,
>
> This patch looks fine.
>
> Acked-by: Adam Radford <aradford@gmail.com>
>
> -Adam


Hi Adam!

What happened to this patch?


Kind regards
Rickard Strandqvist
