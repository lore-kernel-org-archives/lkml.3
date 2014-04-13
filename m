Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbaDMWCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 18:02:25 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60846 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaDMWCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 18:02:22 -0400
X-Auth-Info: NgIc+6jCuTG5jXq0WS5JzJzpGZhcZIwgMVChXMAJIgQ=
From: Marek Vasut <marex@denx.de>
To: grmoore@altera.com
Subject: Re: [PATCH V2] Add support for flag status register on Micron chips.
Date: Sun, 13 Apr 2014 19:18:45 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: ggrahammoore@gmail.com, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Insop Song <insop.song@gainspeed.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
References: <1397228593-17996-1-git-send-email-grmoore@altera.com>
In-Reply-To: <1397228593-17996-1-git-send-email-grmoore@altera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404131918.45753.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 11, 2014 at 05:03:13 PM, grmoore@altera.com wrote:
[...]
> diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
> index ad19139..4cddbc8 100644
> --- a/drivers/mtd/devices/m25p80.c
> +++ b/drivers/mtd/devices/m25p80.c
> @@ -39,6 +39,7 @@
>  #define	OPCODE_WREN		0x06	/* Write enable */
>  #define	OPCODE_RDSR		0x05	/* Read status register */
>  #define	OPCODE_WRSR		0x01	/* Write status register 1 byte 
*/
> +#define	OPCODE_RDFSR		0x70  /* read flag status register */

I know this is not your fault, but can you please indent this properly with 
tabs?

>  #define	OPCODE_NORM_READ	0x03	/* Read data bytes (low 
frequency) */
>  #define	OPCODE_FAST_READ	0x0b	/* Read data bytes (high 
frequency) */
>  #define	OPCODE_QUAD_READ        0x6b    /* Read data bytes */

And fix this one in a separate patch to use tabs as well please ?

[...]

> @@ -790,7 +847,7 @@ static int m25p80_unlock(struct mtd_info *mtd, loff_t
> ofs, uint64_t len)
> 
>  	mutex_lock(&flash->lock);
>  	/* Wait until finished previous command */
> -	if (wait_till_ready(flash)) {
> +	if (flash->wait_till_ready(flash)) {

I wonder, can't wait_till_ready() be made a wrapper that will check the USE_FSR 
flag and call correct wait-function ? This would avoid adding a new member to 
*flash and also would avoid so many changes throughout the code. What do you 
think?
[...]
Best regards,
Marek Vasut
