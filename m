Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3FEH0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:26:17 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50738 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3FEH0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:26:15 -0400
Message-ID: <51AEE7C0.9060206@biophys.uni-duesseldorf.de>
Date: Wed, 05 Jun 2013 19:24:48 +1200
From: schmitz <schmitz@biophys.uni-duesseldorf.de>
User-Agent: Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
        schmitz@debian.org, Sam Ravnborg <sam@ravnborg.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>
Subject: Re: [PATCH] arch: m68k: include: asm: the 3rd parameter of 'insl'
 and 'outsl' need '<< 2'
References: <51A71E49.1000707@asianux.com> <CAMuHMdUz8o4d=RiAMW8-pCrnZyfoH9EETVqjcb7E1GqCgYmQ7g@mail.gmail.com> <51A93FA0.1050203@biophys.uni-duesseldorf.de> <51A94281.7050708@biophys.uni-duesseldorf.de> <51AC6472.3060606@asianux.com> <CAMuHMdVLA_zgeGxTTzfXnBYZiihH3w+LLcW0cRzVk_dvkFojgg@mail.gmail.com> <51AE87DF.5000301@asianux.com>
In-Reply-To: <51AE87DF.5000301@asianux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen,
> On 06/03/2013 06:48 PM, Geert Uytterhoeven wrote:
>   
>>>>>> This _only_ applies to use of insl/outsl macros in parport_pc.h, which
>>>>>> is only used by Q40 on m68k. I see no reason to change anything in io.h
>>>>>> to cope with this warning.
>>>>>>             
>
> I guess your meaning is :
>
> ----------------------------diff begin----------------------------------
>
> diff --git a/arch/m68k/include/asm/parport.h b/arch/m68k/include/asm/parport.h
> index 5ea75e6..dd1672a 100644
> --- a/arch/m68k/include/asm/parport.h
> +++ b/arch/m68k/include/asm/parport.h
> @@ -11,9 +11,20 @@
>  #ifndef _ASM_M68K_PARPORT_H
>  #define _ASM_M68K_PARPORT_H 1
>  
> +#ifdef CONFIG_Q40 /* for Q40, need redefine insl/outsl */
> +
> +#ifdef insl
> +#undef insl
> +#endif
>  #define insl(port,buf,len)   isa_insb(port,buf,(len)<<2)
> +
> +#ifdef outsl
> +#undef outsl
> +#endif
>  #define outsl(port,buf,len)  isa_outsb(port,buf,(len)<<2)
>  
> +#endif /* CONFIG_Q40 */
> +
>  /* no dma, or IRQ autoprobing */
>  static int parport_pc_find_isa_ports (int autoirq, int autodma);
>  static int parport_pc_find_nonpci_ports (int autoirq, int autodma)
>
> ----------------------------diff end------------------------------------
>   

No need for the #ifdef CONFIG_Q40 - Q40 is the only m68k subarch that 
builds the parport_pc module (which includes parport.h), IIRC. Is that 
correct, Thorsten?

>>>> It sounds reasonable.
>>>>
>>>> And excuse me, could you provide the related link directly ?  I don't
>>>> know how to see the detail of 'loom.20130511T171757-995@post.gmane.org'.
>>>>         
>> http://www.spinics.net/lists/linux-m68k/msg06041.html
>>     
>
> OK, thanks.  And sorry for replying late (during these days, I have to
> do another things, and almost can not connect net).
>
>   
Thanks indeed for the link, Geert. I haven't yet had time to test 
whether the io.h patch would interfere with Atari IDE or other drivers's 
use of these macros - maybe this weekend.
> It seems already has another related patch for it, and it is just
> applying.
>
> So need I send it again ?
>
>   
I think Thorsten submitted a patch to that effect? If so, yours should 
not be necessary.

Regards,

    Michael

