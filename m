Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3EQDsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:48:08 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:54183 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab3EQDsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:48:06 -0400
Message-ID: <5195A836.3010002@mvista.com>
Date: Thu, 16 May 2013 22:47:02 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH 3/4] ipmi: Improve error messages on failed irq enable
References: <1368731067-31404-1-git-send-email-cminyard@mvista.com> <1368731067-31404-4-git-send-email-cminyard@mvista.com> <CALCETrXu2At7pRWReYpdFa6OgY79M4KiEKXR=beH+5FcTOL6zg@mail.gmail.com>
In-Reply-To: <CALCETrXu2At7pRWReYpdFa6OgY79M4KiEKXR=beH+5FcTOL6zg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 05:23 PM, Andy Lutomirski wrote:
>
>                  /* We got the flags from the SMI, now handle them. */
>                  smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
> -               if (msg[2] != 0)
> -                       dev_warn(smi_info->dev, "Could not enable interrupts"
> -                                ", failed set, using polled mode.\n");
> -               else
> +               if (msg[2] != 0) {
> +                       dev_warn(smi_info->dev,
> +                                "Couldn't set irq info: %x.\n", msg[2]);
> +                       dev_warn(smi_info->dev,
> +                                "Maybe ok, but ipmi might run very slowly.\n");
> +               } else
> Minor nit: it would be nice if these warnings were collapsed into a
> single printk -- that would save me a whitelist entry of acceptable
> KERN_WARNING messages :)

Yeah, the trouble is that checkpatch will give a warning if you split a 
string
between two lines or if a line is longer than 80 characters.  I'm not 
creative
enough to fit it into a single line.  Maybe I'm trying to be too literal 
here,
but I split it into two prints to avoid the warning.

>
> My Dell 12g server says:
>
> [97627.407724] ipmi_si ipmi_si.0: Using irq 10
> [97627.421369] ipmi_si ipmi_si.0: Couldn't set irq info: cc.
> [97627.427389] ipmi_si ipmi_si.0: Maybe ok, but ipmi might run very slowly.
>
> Tested-by: Andy Lutomirski <luto@amacapital.net>

Thanks a bunch.

-corey

> --Andy

