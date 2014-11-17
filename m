Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaKQRIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:08:30 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:34819 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaKQRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:08:28 -0500
MIME-Version: 1.0
In-Reply-To: <1416224580-4782-1-git-send-email-geert+renesas@glider.be>
References: <1416224580-4782-1-git-send-email-geert+renesas@glider.be>
Date: Mon, 17 Nov 2014 15:08:25 -0200
Message-ID: <CAOMZO5BsfCfP+bMfYWZ9C=Sp0sWkEr6WoRRygw18EfW2T_k3oQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: core: Fix probing of i2c slaves without interrupts
From: Fabio Estevam <festevam@gmail.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 9:43 AM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Since commit 2fd36c55264926e2 ("i2c: core: Map OF IRQ at probe time"),
> i2c slaves without interrupts (e.g. da9210 and at24 on r8a7791/koelsch)
> fail to probe:
>
>     at24: probe of 2-0050 failed with error -22
>
>     da9210: probe of 6-0068 failed with error -22
>
> This happens because the call to of_irq_get() in i2c_device_probe()
> returns -EINVAL.
>
> If a device node does not have an "interrupts" property,
> of_irq_parse_one() fails. Unlike irq_of_parse_and_map(), of_irq_get()
> does not ignore errors from of_irq_parse_one(), but forwards them.
>
> Make i2c_device_probe() ignore all errors but -EPROBE_DEFER to fix this,
> just like platform_get_irq() and platform_get_irq_byname() already do.
>
> Fixes: 2fd36c55264926e2 ("i2c: core: Map OF IRQ at probe time")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

With this patch applied my codec and PMIC can be probed again:

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

Thanks
