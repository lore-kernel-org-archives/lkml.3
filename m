Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617Ab3JPSs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:48:27 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:65261 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761225Ab3JPSsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:48:25 -0400
MIME-Version: 1.0
In-Reply-To: <20131016184133.GB21932@core.coreip.homeip.net>
References: <1381939512-28534-1-git-send-email-geyslan@gmail.com>
	<20131016184133.GB21932@core.coreip.homeip.net>
Date: Wed, 16 Oct 2013 15:48:24 -0300
Message-ID: <CAGG-pUQFCOh6oCfYdtb4Hfuo5V65+7z5Z6D-rF9-EEw25=whSw@mail.gmail.com>
Subject: Re: [PATCH] drivers: input: mouse: Remove useless casting in cypress_ps2.c
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: dudl@cypress.com, kamal@canonical.com, mario_limonciello@dell.com,
        git@status.e4ward.com, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/16 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> Hi Geyslan,
>
> On Wed, Oct 16, 2013 at 01:05:12PM -0300, Geyslan G. Bem wrote:
>> Casting (void *) value returned by kzalloc is useless
>> as mentioned in Documentation/CodingStyle, Chap 14.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> ---
>>  drivers/input/mouse/cypress_ps2.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
>> index f51765f..ef651cc 100644
>> --- a/drivers/input/mouse/cypress_ps2.c
>> +++ b/drivers/input/mouse/cypress_ps2.c
>> @@ -679,7 +679,7 @@ int cypress_init(struct psmouse *psmouse)
>>  {
>>       struct cytp_data *cytp;
>>
>> -     cytp = (struct cytp_data *)kzalloc(sizeof(struct cytp_data), GFP_KERNEL);
>> +     cytp = kzalloc(sizeof(struct cytp_data), GFP_KERNEL);
>
> I already have a patch for this from Jingoo Han in my queue.

No problem.
>
>>       psmouse->private = (void *)cytp;
>
> But this cast is also not needed, so if you could send me a patch for it
> I'd appreciate that.

Sure, I can.
>
>>       if (cytp == NULL)
>>               return -ENOMEM;
>> --
>> 1.8.4
>>
>
> Thanks.
>
> --
> Dmitry
