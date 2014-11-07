Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaKGMmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:42:11 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:33219 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaKGMmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:42:07 -0500
MIME-Version: 1.0
X-Originating-IP: [92.2.245.204]
In-Reply-To: <54514BF6.1010201@nod.at>
References: <1414594338-14695-1-git-send-email-richard@nod.at>
	<CAPcvp5HBnuAHTwFHLJ1Ve6o2MSeQ8Qnn6x7Q0wD2G-yP6p7OLA@mail.gmail.com>
	<54514BF6.1010201@nod.at>
Date: Fri, 7 Nov 2014 12:42:06 +0000
Message-ID: <CAPcvp5Eugd79bLV7e8kOL_Lhut1KeYYu5eZby9kQUee0j5sJqQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] UBI: Implement UBI_METAONLY
From: Andrew Murray <amurray@embedded-bits.co.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 October 2014 20:20, Richard Weinberger <richard@nod.at> wrote:
> Am 29.10.2014 um 21:11 schrieb Andrew Murray:
>> On 29 October 2014 14:52, Richard Weinberger <richard@nod.at> wrote:
>>> diff --git a/include/linux/mtd/ubi.h b/include/linux/mtd/ubi.h
>>> index c3918a0..82b693f 100644
>>> --- a/include/linux/mtd/ubi.h
>>> +++ b/include/linux/mtd/ubi.h
>>> @@ -34,11 +34,13 @@
>>>   * UBI_READONLY: read-only mode
>>>   * UBI_READWRITE: read-write mode
>>>   * UBI_EXCLUSIVE: exclusive mode
>>> + * UBI_METAONLY: modify voulme meta data only
>>
>> Typo - s/voulme/volume/g
>
> Thanks. :)
>
>>>   */
>>>  enum {
>>>         UBI_READONLY = 1,
>>>         UBI_READWRITE,
>>> -       UBI_EXCLUSIVE
>>> +       UBI_EXCLUSIVE,
>>> +       UBI_METAONLY
>>>  };
>>>
>>
>> Also you may want to add something similar to this:
>>
>> --- a/drivers/mtd/ubi/ubi.h
>> +++ b/drivers/mtd/ubi/ubi.h
>> @@ -339,7 +339,7 @@ struct ubi_volume {
>>  /**
>>   * struct ubi_volume_desc - UBI volume descriptor returned when it is opened.
>>   * @vol: reference to the corresponding volume description object
>> - * @mode: open mode (%UBI_READONLY, %UBI_READWRITE, or %UBI_EXCLUSIVE)
>> + * @mode: open mode (%UBI_READONLY, %UBI_READWRITE, %UBI_EXCLUSIVE or
>> %UBI_METAONLY)
>>   */
>>  struct ubi_volume_desc {
>>         struct ubi_volume *vol;
>>
>> There is also a similar mention in gluebi.c: 'readers/writes/exclusive'.
>
> Please send a patch for that. :)

Apologies for the delay - did you just want junk a hunk so you can
include in your next revision - or did you want me to come up with a
v2 of your patch?

Andrew Murray

>
> Thanks,
> //richard
