Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab3GRHEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:04:38 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55481 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab3GRHEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:04:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130717.182237.906875287830581782.davem@davemloft.net>
References: <1374063905-4050-1-git-send-email-geert@linux-m68k.org>
	<20130717.182237.906875287830581782.davem@davemloft.net>
Date: Thu, 18 Jul 2013 09:04:36 +0200
X-Google-Sender-Auth: o6vNRNwuVXJ87NI7ZGDmlHjz5RE
Message-ID: <CAMuHMdWeKuFVd-8_XRzWmJNp11cHP6wRj7K96v=D9We2=XyAgw@mail.gmail.com>
Subject: Re: [PATCH] net/sun3_82586: Kill array subscript above array bounds warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: Sam Creasey <sammy@sammy.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 3:22 AM, David Miller <davem@davemloft.net> wrote:
>> drivers/net/ethernet/i825xx/sun3_82586.c: In function 'sun3_82586_timeout':
>> drivers/net/ethernet/i825xx/sun3_82586.c:993:89: warning: array subscript is above array bounds [-Warray-bounds]
>>
>> Using the default NUM_XMIT_BUFFS = 1, there's only one transmit buffer.
>> Hence accessing the second buffer is an out-of-bounds access.
>> Print the command status of the first NOP buffer instead.
>>
>> Fortunately this actually worked fine, as the layout of transmit and NOP
>> buffers is sufficiently similar.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Three more CPP directives in a DEBUG ifdef'd piece of code, yuck.
>
> I'd say just kill this whole DEBUG section entirely.  If people
> want this driver to print this debugging, do it properly with
> netif_err() or similar.

Yeah, this driver could use some major cleanup. I had to protect my eyes while
fixing the compiler warning.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
