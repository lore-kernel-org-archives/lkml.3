Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbaLVXIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:08:19 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:61386 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbaLVXIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:08:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAFo99gaY5MQ2uDWOGkQgJxseNorv0NRNY3PVJg395gqHtkKrjg@mail.gmail.com>
References: <1406473878-12715-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CAHtARFFmUJ5_mnJu=yLb8bGXcMNza8oHsThHPb3_QgE-pq4BGg@mail.gmail.com>
	<CAFo99gaY5MQ2uDWOGkQgJxseNorv0NRNY3PVJg395gqHtkKrjg@mail.gmail.com>
Date: Mon, 22 Dec 2014 15:08:14 -0800
Message-ID: <CAHtARFEVpwPw=OmPvPAxcaiANG_V4f+NBX4g67iCwutvWs=eSg@mail.gmail.com>
Subject: Re: [PATCH] scsi: 3w-9xxx.c: Cleaning up missing null-terminate in
 conjunction with strncpy
From: adam radford <aradford@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Adam Radford <linuxraid@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 2:52 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> 2014-08-01 0:19 GMT+02:00 adam radford <aradford@gmail.com>:
>> On Sun, Jul 27, 2014 at 8:11 AM, Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se> wrote:
>>> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>>> And use the sizeof on the to string rather than strlen on the from string.
>>>
>>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>>> ---
>>>  drivers/scsi/3w-9xxx.c |    3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
>>> index 0a73253..f4d2331 100644
>>> --- a/drivers/scsi/3w-9xxx.c
>>> +++ b/drivers/scsi/3w-9xxx.c
>>> @@ -621,7 +621,8 @@ static int twa_check_srl(TW_Device_Extension *tw_dev, int *flashed)
>>>         }
>>>
>>>         /* Load rest of compatibility struct */
>>> -       strncpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION, strlen(TW_DRIVER_VERSION));
>>> +       strlcpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION,
>>> +               sizeof(tw_dev->tw_compat_info.driver_version));
>>>         tw_dev->tw_compat_info.driver_srl_high = TW_CURRENT_DRIVER_SRL;
>>>         tw_dev->tw_compat_info.driver_branch_high = TW_CURRENT_DRIVER_BRANCH;
>>>         tw_dev->tw_compat_info.driver_build_high = TW_CURRENT_DRIVER_BUILD;
>>> --
>>> 1.7.10.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>> Rickard,
>>
>> This patch looks fine.
>>
>> Acked-by: Adam Radford <aradford@gmail.com>
>>
>> -Adam
>
>
> Hi Adam!
>
> What happened to this patch?

It just didn't get picked up into scsi.git/for-next for some reason.

All I can do is Ack it, which I already did :)

-Adam
