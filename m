Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbaDIKHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:07:25 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:49701 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaDIKHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:07:19 -0400
X-Auth-Info: pl+OQV9d+GQ6AJ+iUAMV35B96jJcIhgJQyUHLDHW1og=
From: Marek Vasut <marex@denx.de>
To: grmoore@altera.com
Subject: Re: [PATCH] Add support for flag status register on Micron chips.
Date: Wed, 9 Apr 2014 12:06:45 +0200
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
References: <1396973570-13995-1-git-send-email-grmoore@altera.com> <1396973570-13995-2-git-send-email-grmoore@altera.com>
In-Reply-To: <1396973570-13995-2-git-send-email-grmoore@altera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404091206.45967.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 08, 2014 at 06:12:50 PM, grmoore@altera.com wrote:
> From: Graham Moore <grmoore@altera.com>
> 
> Some new Micron flash chips require reading the flag
> status register to determine when operations have completed.
> 
> Furthermore, chips with multi-die stacks of the 65nm 256Mb QSPI also
> require reading the status register before reading the flag status
> register.
> 
> This patch adds support for the flag status register in the n25q512a1 and
> n25q00 Micron QSPI flash chips.

[...]

> +static int read_fsr(struct m25p *flash)
> +{
> +	ssize_t retval;
> +	u8 code = OPCODE_RDFSR;
> +	u8 val;
> +
> +	retval = spi_write_then_read(flash->spi, &code, 1, &val, 1);
> +
> +	if (retval < 0) {
> +		dev_err(&flash->spi->dev, "error %d reading FSR\n",
> +				(int) retval);

Is the type-cast really needed here? Why ?

> +		return retval;
> +	}
> +
> +	return val;
> +}
> +/*
>   * Read configuration register, returning its value in the
>   * location. Return the configuration register value.
>   * Returns negative if error occured.
> @@ -233,7 +259,7 @@ static inline int set_4byte(struct m25p *flash, u32
> jedec_id, int enable) * Service routine to read status register until
> ready, or timeout occurs. * Returns non-zero if error.
>   */
> -static int wait_till_ready(struct m25p *flash)
> +static int _wait_till_ready(struct m25p *flash)

Please avoid using function names that start with underscore .
[...]

Thanks!

Best regards,
Marek Vasut
