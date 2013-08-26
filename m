Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab3HZKCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:02:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58403 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756039Ab3HZKCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:02:04 -0400
Date: Mon, 26 Aug 2013 12:02:00 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>, <mturquette@linaro.org>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] arm: mvebu: add missing of_node_put() to fix
 reference leak
Message-ID: <20130826120200.2269ba82@skate>
In-Reply-To: <1377510981-1793-2-git-send-email-jszhang@marvell.com>
References: <1377510981-1793-1-git-send-email-jszhang@marvell.com>
	<1377510981-1793-2-git-send-email-jszhang@marvell.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jisheng Zhang,

On Mon, 26 Aug 2013 17:56:19 +0800, Jisheng Zhang wrote:

> diff --git a/arch/arm/mach-mvebu/armada-370-xp.c b/arch/arm/mach-mvebu/armada-370-xp.c
> index 97cbb80..8a1ae83 100644
> --- a/arch/arm/mach-mvebu/armada-370-xp.c
> +++ b/arch/arm/mach-mvebu/armada-370-xp.c
> @@ -64,6 +64,7 @@ static void __init armada_370_xp_mbus_init(void)
>  			ARMADA_370_XP_MBUS_WINS_SIZE,
>  			of_translate_address(dn, &sdram_wins_offs),
>  			ARMADA_370_XP_SDRAM_WINS_SIZE);
> +	of_node_put(dn);
>  }

With the integration of Ezequiel patches that add DT support to the
mvebu-mbus driver, this chunk of the code is no longer needed, as of
linux-next.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
