Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab3K0WMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:12:35 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:62679 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3K0WMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:12:32 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Andrew Victor" <linux@maxim.org.za>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        "Russell King" <linux@arm.linux.org.uk>, "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        "Josh Wu" <josh.wu@atmel.com>,
        "Richard Genoud" <richard.genoud@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1384293935-4755-1-git-send-email-b.brezillon@overkiz.com>
Cc: "Boris BREZILLON" <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
References: <1384289513-3068-1-git-send-email-b.brezillon@overkiz.com>
 <1384293935-4755-1-git-send-email-b.brezillon@overkiz.com>
Message-ID: <20131127220529.16819.42204@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 08/17] clk: at91: add PMC system clocks
Date: Wed, 27 Nov 2013 14:05:29 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Boris BREZILLON (2013-11-12 14:05:35)
> This patch adds new at91 system clock implementation using common clk
> framework.
> 
> Some peripherals need to enable a "system" clock in order to work properly.
> Each system clock is given an id based on the bit position in SCER/SCDR
> registers.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/clk/at91/Makefile     |    1 +
>  drivers/clk/at91/clk-system.c |  137 +++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/at91/pmc.c        |    5 ++
>  drivers/clk/at91/pmc.h        |    3 +
>  4 files changed, 146 insertions(+)
>  create mode 100644 drivers/clk/at91/clk-system.c
> 
> diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
> index e28fb2b..c2b7068 100644
> --- a/drivers/clk/at91/Makefile
> +++ b/drivers/clk/at91/Makefile
> @@ -4,3 +4,4 @@
>  
>  obj-y += pmc.o
>  obj-y += clk-main.o clk-pll.o clk-plldiv.o clk-master.o
> +obj-y += clk-system.o
> diff --git a/drivers/clk/at91/clk-system.c b/drivers/clk/at91/clk-system.c
> new file mode 100644
> index 0000000..1c086f4
> --- /dev/null
> +++ b/drivers/clk/at91/clk-system.c
> @@ -0,0 +1,137 @@
> +/*
> + * drivers/clk/at91/clk-system.c

Nitpick: it's better to not put file paths in a comment block in case
the file name or path is changed.

Regards,
Mike
