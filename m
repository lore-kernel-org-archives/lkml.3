Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbaFCPT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:19:59 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:53941 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaFCPT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140603141138.GH16741@pengutronix.de>
References: <20140429100028.GH28564@pengutronix.de>
	<20140602085150.GA31147@pengutronix.de>
	<538DBC3F.9060207@uclinux.org>
	<20140603141138.GH16741@pengutronix.de>
Date: Tue, 3 Jun 2014 17:19:56 +0200
X-Google-Sender-Auth: 9CmwgWTqPfEgaWrqCag7Eb7tdDE
Message-ID: <CAMuHMdXpOcWhsjMRaW6YVeK4g-QJN7WNkRHD+q4==GkBPp5=0w@mail.gmail.com>
Subject: Re: TASK_SIZE for !MMU
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg Ungerer <gerg@uclinux.org>, Rabin Vincent <rabin@rab.in>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        linux-m32r@ml.linux-m32r.org, linux-c6x-dev@linux-c6x.org,
        microblaze-uclinux@itee.uq.edu.au,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, Linux MM <linux-mm@kvack.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        panchaxari <panchaxari.prasannamurthy@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 4:11 PM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
>> I did that same change for m68k in commit cc24c40 ("m68knommu: remove
>> size limit on non-MMU TASK_SIZE"). For similar reasons as you need to
>> now.
> ok.
>
>> >>Thoughts?
>> >The problem is that current linus/master (and also next) doesn't boot on
>> >my ARM-nommu machine because the user string functions (strnlen_user,
>> >strncpy_from_user et al.) refuse to work on strings above TASK_SIZE
>> >which in my case also includes the XIP kernel image.
>>
>> I seem to recall that we were not considering flash or anything else
>> other than RAM when defining that original TASK_SIZE (back many, many
>> years ago). Some of the address checks you list above made some sense
>> if you had everything in RAM (though only upper bounds are checked).
>> The thinking was some checking is better than none I suppose.
> What is the actual meaning of TASK_SIZE? The maximal value of a valid
> userspace address?

Yes

$ git show cc24c40
commit cc24c405949e3d4418a90014d10166679d78141a
Author: Greg Ungerer <gerg@uclinux.org>
Date:   Mon May 24 11:22:05 2010 +1000

    m68knommu: remove size limit on non-MMU TASK_SIZE

    The TASK_SIZE define is used in some places as a limit on the size of
    the virtual address space of a process. On non-MMU systems those addresses
    used in comparison will be physical addresses, and they could be anywhere
    in the 32bit physical address space. So for !CONFIG_MMU systems set the
    TASK_SIZE to the maximum physical address.

    Signed-off-by: Greg Ungerer <gerg@uclinux.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
