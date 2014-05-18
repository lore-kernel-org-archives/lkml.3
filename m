Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaEREwI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 00:52:08 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:43645 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaEREwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 00:52:07 -0400
MIME-Version: 1.0
In-Reply-To: <1400386345.14720.3.camel@joe-AO725>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
 <1400385604-21086-2-git-send-email-matlackdavid@gmail.com> <1400386345.14720.3.camel@joe-AO725>
From: David Matlack <matlackdavid@gmail.com>
Date: Sat, 17 May 2014 21:51:45 -0700
Message-ID: <CANoiuGJC4CcZf-dzBQjFE72eBsb0zXTy4vxeE87cngT=kEiTVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: slicoss: rewrite eeprom checksum code
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Lior Dotan <liodot@gmail.com>,
        charrer@alacritech.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 9:12 PM, Joe Perches <joe@perches.com> wrote:
> On Sat, 2014-05-17 at 21:00 -0700, David Matlack wrote:
> []
>> diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
> []
>> +static inline u16 __reduce(u32 checksum)
>> +{
>> +     u16 lower_16 = checksum & 0xFFFF;
>> +     u16 upper_16 = (checksum >> 16) & 0xFFFF;
>> +
>> +     checksum = lower_16 + upper_16;
>> +
>> +     if (checksum > 65535)
>> +             checksum -= 65535;
>> +
>> +     return checksum;
>> +}
>
> The if seems unnecessary.
>
> Perhaps declare a u16 return var or use
>
>         return lower_16 + upper_16;

I agree it's fishy... but using overflow doesn't produce the same result:

         (u16) 65536   == 0
         65536 - 65535 == 1

Now which is the correct result, I have no idea. The eeprom on this device is
small (0x80 bytes max, not enough to trigger overflow) and I have no
documentation, so I don't know how to test :(
