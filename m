Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaGBFU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:20:27 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58968 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaGBFUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:20:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Manuel Lauss <manuel.lauss@gmail.com>,
        "Linux-MIPS" <linux-mips@linux-mips.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1404061055-89797-3-git-send-email-manuel.lauss@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Manuel Lauss" <manuel.lauss@gmail.com>
References: <1404061055-89797-1-git-send-email-manuel.lauss@gmail.com>
 <1404061055-89797-3-git-send-email-manuel.lauss@gmail.com>
Message-ID: <20140702052012.23338.54536@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 2/2] MIPS: Alchemy: common clock framework integration
Date: Tue, 01 Jul 2014 22:20:12 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Manuel Lauss (2014-06-29 09:57:35)
> Expose chip-internal configurable clocks to the common clk framework,
> and fix a few drivers to take advantage of it.

Thanks for the patch series! Both patches cover a lot of ground, but
I'll focus on #2. It would be best to split the driver changes out
separately. You can introduce the common clk changes but not compile
them in, then change the drivers, then add the logic to compile the new
common clock driver all as separate patches.

<snip>

> diff --git a/arch/mips/alchemy/common/Makefile b/arch/mips/alchemy/common/Makefile
> index cb83d8d..2e4d505 100644
> --- a/arch/mips/alchemy/common/Makefile
> +++ b/arch/mips/alchemy/common/Makefile
> @@ -5,7 +5,7 @@
>  # Makefile for the Alchemy Au1xx0 CPUs, generic files.
>  #
>  
> -obj-y += prom.o time.o clocks.o platform.o power.o setup.o \
> +obj-y += prom.o time.o clock.o platform.o power.o setup.o \
>         sleeper.o dma.o dbdma.o vss.o irq.o usb.o

As stated above, in the first patch only introduce
arch/mips/alchemy/common/clock, but don't compile it here in the
Makefile.

A quick glance through clock.c below looks pretty good. I'll go through
it in more detail once the other parts of the series are split out.

Additionally, it would be cool to push this driver out to drivers/clk/
if you are so inclined. It looks like your header dependencies are not
so bad as to make that task impossible. Just a suggestion from me.

Regards,
Mike
