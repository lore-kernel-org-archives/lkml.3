Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaGWE4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:56:23 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56906 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaGWE4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:56:21 -0400
MIME-Version: 1.0
In-Reply-To: <53CF3FFB.4080809@roeck-us.net>
References: <1406088515-4026-1-git-send-email-xerofoify@gmail.com>
	<53CF3FFB.4080809@roeck-us.net>
Date: Wed, 23 Jul 2014 00:56:21 -0400
Message-ID: <CAPDOMVgJ1-L0wvxwkdut9XDsAHNFd_VsEN75W_Thn1P-phgnuw@mail.gmail.com>
Subject: Re: [PATCH] m68k: Remove printk statement and add return statement in q40ints.c
From: Nick Krause <xerofoify@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:54 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 07/22/2014 09:08 PM, Nicholas Krause wrote:
>>
>> This removes the printk statement for irqs not defined by the hardware in
>> function q40_irq_startup and instead returns -ENXIO as stated by the fix
>> me message.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>   arch/m68k/q40/q40ints.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
>> index 513f9bb..86f05c0 100644
>> --- a/arch/m68k/q40/q40ints.c
>> +++ b/arch/m68k/q40/q40ints.c
>> @@ -48,8 +48,7 @@ static unsigned int q40_irq_startup(struct irq_data
>> *data)
>>         switch (irq) {
>>         case 1: case 2: case 8: case 9:
>>         case 11: case 12: case 13:
>> -               printk("%s: ISA IRQ %d not implemented by HW\n", __func__,
>> irq);
>> -               /* FIXME return -ENXIO; */
>> +               return -ENXIO;
>
>
> Returning -ENXIO from a function returning an unsigned int isn't really very
> helpful,
> don't you think ?
>
> With all those FIXMEs, you might want to keep in mind that there is
> typically a
> good reason for it. If it was as easy as your proposed fix, you can assume
> that the FIXME would not have been there in the first place.
>
> Guenter
>


Sorry Guenter,
That's fine. can I can change  the return type of the function or is
that going to break things?
Nick
