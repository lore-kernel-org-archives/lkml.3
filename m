Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab3CMNER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:04:17 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54998 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3CMNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:04:16 -0400
MIME-Version: 1.0
In-Reply-To: <1363172096.11441.11.camel@sauron.fi.intel.com>
References: <1362653364-29993-1-git-send-email-b32955@freescale.com>
	<1362653364-29993-2-git-send-email-b32955@freescale.com>
	<1363172096.11441.11.camel@sauron.fi.intel.com>
Date: Wed, 13 Mar 2013 21:04:16 +0800
Message-ID: <CAMiH66HyH7tQG96UMKed6prpqBa=sgyntdO1pf0yG+=qyigY0Q@mail.gmail.com>
Subject: Re: [PATCH V4 1/3] mtd: add new fields to nand_flash_dev{}
From: Huang Shijie <shijie8@gmail.com>
To: artem.bityutskiy@linux.intel.com
Cc: Huang Shijie <b32955@freescale.com>, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 6:54 PM, Artem Bityutskiy
<artem.bityutskiy@linux.intel.com> wrote:
> On Thu, 2013-03-07 at 18:49 +0800, Huang Shijie wrote:
>> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
>> index 591eeeb..f0a9d93 100644
>> --- a/include/linux/mtd/nand.h
>> +++ b/include/linux/mtd/nand.h
>> @@ -578,6 +578,8 @@ struct nand_chip {
>>   * @erasesize: eraseblock size in bytes (determined from the extended ID if 0)
>>   * @chipsize: total chip size in MiB
>>   * @options: stores various chip bit options
>> + * @id_len: The valid length of the @id.
>> + * @oobsize: OOB size
>>   */
>>  struct nand_flash_dev {
>>       char *name;
>> @@ -592,6 +594,8 @@ struct nand_flash_dev {
>>       unsigned long chipsize;
>>       unsigned long erasesize;
>>       unsigned long options;
>> +     unsigned long id_len;
>> +     unsigned long oobsize;
>>  };
>
> Why are these of type 'long', which is 64 bits in 64-bit architectures,
> which seems to be unnecessarily big. Wouldn't 'unsigned int' be enough?
>
Frankly speaking, "uint16_t" is enough.
"unsigned int" is too long for both the fields.

> Also, can we avoid having the 'id_len' field? Can the end of the

For these 4 toshiba nand, we do not need the id_len field.

> sequence of ID's be marked with a '0' or '0xFF' marker instead?

Are you sure that 0 or 0xff are not the valid data during the 8byte id data?
I am not sure.

Maybe in future, we may meet a nand which use the 0xff as a valid id-data.

But we can remove this id_len field now. It's ok to me.

thanks
Huang Shijie

>
> --
> Best Regards,
> Artem Bityutskiy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
