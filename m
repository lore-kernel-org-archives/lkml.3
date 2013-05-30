Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030257Ab3E3JJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:09:57 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:59865 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030209Ab3E3JJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXBk6vMFNOJVsxYnt8qvuQN2xveXFaSTM8tUTbiEgPArQ@mail.gmail.com>
References: <CAMuHMdV8gJew_x1+L3O51sB=JU_EvJ-Y05JxKSsXUi+B43HAJA@mail.gmail.com>
	<1369756432-5552-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369756432-5552-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAMuHMdXBk6vMFNOJVsxYnt8qvuQN2xveXFaSTM8tUTbiEgPArQ@mail.gmail.com>
Date: Thu, 30 May 2013 12:09:48 +0300
Message-ID: <CAHp75Ve+kEmV6PLwaybAS1eWN6MUZQDLYXXfzz115R40-5+yWw@mail.gmail.com>
Subject: Re: [PATCH] cris: kgdb: use native hex2bin
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cris <linux-cris-kernel@axis.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 10:57 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, May 28, 2013 at 5:53 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
>> index 37e6d2c..07bccd8 100644
>> --- a/arch/cris/arch-v10/kernel/kgdb.c
>> +++ b/arch/cris/arch-v10/kernel/kgdb.c
>
>> @@ -659,18 +651,6 @@ read_register (char regno, unsigned int *valptr)
>>  }
>>
>>  /********************************** Packet I/O ******************************/
>> -/* Returns the integer equivalent of a hexadecimal character. */
>> -static int
>> -hex (char ch)
>> -{
>> -       if ((ch >= 'a') && (ch <= 'f'))
>> -               return (ch - 'a' + 10);
>> -       if ((ch >= '0') && (ch <= '9'))
>> -               return (ch - '0');
>> -       if ((ch >= 'A') && (ch <= 'F'))
>> -               return (ch - 'A' + 10);
>> -       return (-1);
>> -}
>
> This one handles both upper and lower case hex characters, while hex2bin()
> handles lower case only. Is that OK, or should hex2bin be extended?

Its implementation is located in lib/hexdump.c
If you look at it carefully you find that hex2bin calls hex_to_bin()
which services both cases (via using tolower()).

--
With Best Regards,
Andy Shevchenko
