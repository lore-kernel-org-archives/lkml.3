Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaAMJrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:47:14 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46893 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaAMJrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:47:12 -0500
MIME-Version: 1.0
In-Reply-To: <52D3B36D.8040902@codethink.co.uk>
References: <1389367095-7760-1-git-send-email-ben.dooks@codethink.co.uk>
	<CAMuHMdU+SfjNJC_b_7ovT9Uf5p5MwB0iULjorzthcLJxYJ-00g@mail.gmail.com>
	<52D3B36D.8040902@codethink.co.uk>
Date: Mon, 13 Jan 2014 10:47:11 +0100
X-Google-Sender-Auth: yG8Tr2quObdTz18ln2GbOiF5Tts
Message-ID: <CAMuHMdWHywXYJL5j_hNUhhshpegm4s7j=R2Qsh3WuiwnHX5+yg@mail.gmail.com>
Subject: Re: [PATCH] ARM: shmobile: compile drivers/sh for CONFIG_ARCH_SHMOBILE_MULTI
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus SH list <linux-sh@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, Jan 13, 2014 at 10:35 AM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> On 13/01/14 09:28, Geert Uytterhoeven wrote:
>> On Fri, Jan 10, 2014 at 4:18 PM, Ben Dooks <ben.dooks@codethink.co.uk>
>> wrote:
>>>
>>> --- a/drivers/sh/Makefile
>>> +++ b/drivers/sh/Makefile
>>> @@ -3,7 +3,10 @@
>>>   #
>>>   obj-y  := intc/
>>>
>>> +ifeq ($(CONFIG_COMMON_CLK),n)
>>>   obj-$(CONFIG_HAVE_CLK)         += clk/
>>> +endif
>>> +
>>
>>
>> This part breaks my Koelsch legacy (non-reference) build:
>>
>> arch/arm/kernel/built-in.o: In function `twd_local_timer_common_register':
>> io.c:(.init.text+0x1804): undefined reference to `clk_enable'
>> io.c:(.init.text+0x1828): undefined reference to `clk_get_rate'
>
> ...
>
>>
>> Both of my Koelsch legacy and reference configs have CONFIG_HAVE_CLK=y,
>> but only the reference once has CONFIG_COMMON_CLK=y.
>
> Hmm, thought undefined symbols got set to 'n'.

No, they're empty.
Doh, should have realized that myself...

> I can either fix this by
>
> ifneq ($(CONFIG_COMMON_CLK),y)
> endif

That's the typical pattern for this.

Sometimes people use

    obj-$(CONFIG_COMMON_CLK)$(CONFIG_HAVE_CLK) += clk/

but that's less readable.

> or adding an extra Kconfig for SH specific legacy clock code.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
