Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab3A1QBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:01:50 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33329 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3A1QBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:01:49 -0500
MIME-Version: 1.0
In-Reply-To: <20130128151010.GA3470@polaris.bitmath.org>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
	<1359120190-18281-7-git-send-email-benjamin.tissoires@gmail.com>
	<20130128151010.GA3470@polaris.bitmath.org>
Date: Mon, 28 Jan 2013 17:01:47 +0100
Message-ID: <CAN+gG=HBv6iLJGMg8cAAV4RJ+=4eHV-q0zrny71fCXDO6cBE4A@mail.gmail.com>
Subject: Re: [PATCH 06/25] HID: multitouch: optimize FlatFrog panels
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 4:10 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> Relying on ALWAYS_VALID enhance a little the processing time of
>> the events.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/hid-multitouch.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> Is there a measurement backing up this claim? I suspect
> micro-optimizations of this kind drowns completely along the rather
> long way from device, via malloc and loops, to the input core.

No, the measure I made for this are roughly the same. It's purely
micro-optimization, and yes, mallocs must kill the processing time.
However, the purpose of this patch and the others entitled 'optimize
XXX' is to show that I did not invented the new default class. My true
objective is to remove all the quirks related to the 'valid'
information in order to have a driver as universal as possible and to
be able to clean it up.

> Considering the must-be-tested-for-regression risk on top of that,
> this patch falls far below what is worth doing, IMHO.

It _has_ been tested. I got the HID traces from FlatFrog and either
they use different firmwares with different processing in their
devices, the kernel processing is good.

Cheers,
Benjamin

>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 5a886bd..7dfe891 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -229,8 +229,9 @@ static struct mt_class mt_classes[] = {
>>       },
>>
>>       { .name = MT_CLS_FLATFROG,
>> -             .quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
>> -                     MT_QUIRK_NO_AREA,
>> +             .quirks = MT_QUIRK_ALWAYS_VALID |
>> +                     MT_QUIRK_NO_AREA |
>> +                     MT_QUIRK_CONTACT_CNT_ACCURATE,
>>               .sn_move = 2048,
>>               .maxcontacts = 40,
>>       },
>> --
>> 1.8.1
>>
>
> Thanks.
> Henrik
