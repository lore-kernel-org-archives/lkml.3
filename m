Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaAMJft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:35:49 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:38228 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaAMJfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:35:48 -0500
Message-ID: <52D3B36D.8040902@codethink.co.uk>
Date: Mon, 13 Jan 2014 09:35:41 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@lists.codethink.co.uk,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus SH list <linux-sh@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ARM: shmobile: compile drivers/sh for CONFIG_ARCH_SHMOBILE_MULTI
References: <1389367095-7760-1-git-send-email-ben.dooks@codethink.co.uk> <CAMuHMdU+SfjNJC_b_7ovT9Uf5p5MwB0iULjorzthcLJxYJ-00g@mail.gmail.com>
In-Reply-To: <CAMuHMdU+SfjNJC_b_7ovT9Uf5p5MwB0iULjorzthcLJxYJ-00g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/14 09:28, Geert Uytterhoeven wrote:
> On Fri, Jan 10, 2014 at 4:18 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>> --- a/drivers/sh/Makefile
>> +++ b/drivers/sh/Makefile
>> @@ -3,7 +3,10 @@
>>   #
>>   obj-y  := intc/
>>
>> +ifeq ($(CONFIG_COMMON_CLK),n)
>>   obj-$(CONFIG_HAVE_CLK)         += clk/
>> +endif
>> +
>
> This part breaks my Koelsch legacy (non-reference) build:
>
> arch/arm/kernel/built-in.o: In function `twd_local_timer_common_register':
> io.c:(.init.text+0x1804): undefined reference to `clk_enable'
> io.c:(.init.text+0x1828): undefined reference to `clk_get_rate'
...
>
> Both of my Koelsch legacy and reference configs have CONFIG_HAVE_CLK=y,
> but only the reference once has CONFIG_COMMON_CLK=y.

Hmm, thought undefined symbols got set to 'n'.

I can either fix this by

ifneq ($(CONFIG_COMMON_CLK),y)
endif

or adding an extra Kconfig for SH specific legacy clock code.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
