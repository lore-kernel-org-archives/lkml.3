Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbaGWPkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:40:06 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:56898 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbaGWPkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:40:03 -0400
MIME-Version: 1.0
In-Reply-To: <53CFC170.9090505@roeck-us.net>
References: <1406119899-22659-1-git-send-email-sasha.levin@oracle.com>
	<53CFC170.9090505@roeck-us.net>
Date: Wed, 23 Jul 2014 11:39:57 -0400
Message-ID: <CAPDOMVj7mP3uBGKP-pGgc7mrZXyun4rc7xsAi+=faC-hhKUmWQ@mail.gmail.com>
Subject: Re: [PATCH] m68k/q40: Revert "m68k/q40: Fix q40_irq_startup() to
 return -ENXIO on failures"
From: Nick Krause <xerofoify@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-m68k@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:06 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 07/23/2014 05:51 AM, Sasha Levin wrote:
>>
>> Revert since we're trying to return -ENXIO from a function returning
>> unsigned int. Not only it causes compiler warnings it's also obviously
>> incorrect.
>>
>> In general, watch for patches from Nick Krause since they are not even
>> build tested.
>>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>
> Guess I wasn't fast enough with my comments :-(
>
> Acked-by: Guenter Roeck <linux@roeck-us.net>
>
>
>> ---
>>   arch/m68k/q40/q40ints.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
>> index 9dfa1ea..513f9bb 100644
>> --- a/arch/m68k/q40/q40ints.c
>> +++ b/arch/m68k/q40/q40ints.c
>> @@ -49,7 +49,7 @@ static unsigned int q40_irq_startup(struct irq_data
>> *data)
>>         case 1: case 2: case 8: case 9:
>>         case 11: case 12: case 13:
>>                 printk("%s: ISA IRQ %d not implemented by HW\n", __func__,
>> irq);
>> -               return -ENXIO;
>> +               /* FIXME return -ENXIO; */
>>         }
>>         return 0;
>>   }
>>
>


I guess this is another bad patch :(.
Nick
