Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaGZP5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:57:10 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:60874 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaGZP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:57:08 -0400
MIME-Version: 1.0
In-Reply-To: <53D3CA66.8080408@oracle.com>
References: <1406119899-22659-1-git-send-email-sasha.levin@oracle.com>
	<53CFC170.9090505@roeck-us.net>
	<CAMuHMdW=iecARisoUuDY1hNaZgWWZJwpVjXDpXYqscx=myDx+w@mail.gmail.com>
	<53D3CA66.8080408@oracle.com>
Date: Sat, 26 Jul 2014 17:57:06 +0200
X-Google-Sender-Auth: voZx3iT_aGShjqkQeFuaaNLBvn4
Message-ID: <CAMuHMdUYFWLHD+MjeeH_dmcVLSYn0Pb1MzYFdj0ryCBJqaSXjg@mail.gmail.com>
Subject: Re: [PATCH] m68k/q40: Revert "m68k/q40: Fix q40_irq_startup() to
 return -ENXIO on failures"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Steven Rostedt <rostedt@goodmis.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Nick Krause <xerofoify@gmail.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Zidlicky <rz@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 5:33 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> On 07/26/2014 11:21 AM, Geert Uytterhoeven wrote:
>> I applied Nick's cleanup (which is not yet in mainline, just in the m68k repo)
>> because I thought Nick was right (in this particular case ;-), cfr. my
>> reasoning in www.spinics.net/lists/kernel/msg1774736.html
>>
>> W.r.t. the signess, I didn't see the compiler warning, as the version of gcc
>> I'm using didn't print that warning. However, irq_startup() converts the
>> value returned by .irq_startup() from unsigned to signed.
>> I assume this is just a missing conversion when the genirq framework
>> itself was introduced (m68k was converted quite late)?
>>
>> W.r.t. the actual value, any non-zero value is treated the same.
>> I can change it to 1, if that makes you feel better. If returning a non-zero
>> value here is wrong, presumable the code has been wrong since it
>> incarnation.
>>
>> As we're close to the opening of the merge window, it would be nice
>> if we could conclude on this ;-)
>
> From my standpoint there are two issues here:
>
> 1. The whole signed/unsigned mishmash here. Pretty much any solution
> besides implicitly converting a signed value into an unsigned one
> which then gets treated as something else entirely should be acceptable
> here.
>
> 2. Beyond semantics, the original patch also changed the behaviour of
> the code. What previously was a soft printk() is now a hard error.
> Does it break any systems? Cornercases? I dunno, but I can assure you
> that this wasn't tested at all.

If it broke something, it was most probably broken before
commit c288bf2533e57174b90b07860c4391bcd1ea269c ("m68k/irq:
Rename irq_controller to irq_chip"), too.

It seems the Q40 hardware cannot handle this case, so considering this
a hard error looks fine to me (CC Richard Zidlicky).

> To sum it up, a solution would be welcome. The patch you currently have
> in the m68k repo isn't a solution.

OK, reverted. Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
