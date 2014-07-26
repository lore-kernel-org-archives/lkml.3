Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaGZPej (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:34:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40175 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaGZPeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:34:36 -0400
Message-ID: <53D3CA66.8080408@oracle.com>
Date: Sat, 26 Jul 2014 11:33:58 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>
CC: Steven Rostedt <rostedt@goodmis.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Nick Krause <xerofoify@gmail.com>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] m68k/q40: Revert "m68k/q40: Fix q40_irq_startup() to
 return -ENXIO on failures"
References: <1406119899-22659-1-git-send-email-sasha.levin@oracle.com>	<53CFC170.9090505@roeck-us.net> <CAMuHMdW=iecARisoUuDY1hNaZgWWZJwpVjXDpXYqscx=myDx+w@mail.gmail.com>
In-Reply-To: <CAMuHMdW=iecARisoUuDY1hNaZgWWZJwpVjXDpXYqscx=myDx+w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2014 11:21 AM, Geert Uytterhoeven wrote:
> I applied Nick's cleanup (which is not yet in mainline, just in the m68k repo)
> because I thought Nick was right (in this particular case ;-), cfr. my
> reasoning in www.spinics.net/lists/kernel/msg1774736.html
> 
> W.r.t. the signess, I didn't see the compiler warning, as the version of gcc
> I'm using didn't print that warning. However, irq_startup() converts the
> value returned by .irq_startup() from unsigned to signed.
> I assume this is just a missing conversion when the genirq framework
> itself was introduced (m68k was converted quite late)?
> 
> W.r.t. the actual value, any non-zero value is treated the same.
> I can change it to 1, if that makes you feel better. If returning a non-zero
> value here is wrong, presumable the code has been wrong since it
> incarnation.
> 
> As we're close to the opening of the merge window, it would be nice
> if we could conclude on this ;-)

>From my standpoint there are two issues here:

1. The whole signed/unsigned mishmash here. Pretty much any solution
besides implicitly converting a signed value into an unsigned one
which then gets treated as something else entirely should be acceptable
here.

2. Beyond semantics, the original patch also changed the behaviour of
the code. What previously was a soft printk() is now a hard error.
Does it break any systems? Cornercases? I dunno, but I can assure you
that this wasn't tested at all.

To sum it up, a solution would be welcome. The patch you currently have
in the m68k repo isn't a solution.


Thanks,
Sasha
