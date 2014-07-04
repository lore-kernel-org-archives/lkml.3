Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965053AbaGDO6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 10:58:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48711 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbaGDO6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 10:58:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAL8zT=isq_2RT07a6z8imJ4N0w0v-yw6ysv3wf+S7sLsqZBCeg@mail.gmail.com>
References: <CAL8zT=isq_2RT07a6z8imJ4N0w0v-yw6ysv3wf+S7sLsqZBCeg@mail.gmail.com>
Date: Fri, 4 Jul 2014 16:58:02 +0200
X-Google-Sender-Auth: GJv8QP_VNAh4T94SorscmGQt_gg
Message-ID: <CAMuHMdXBpgfVuvpW8gq2XY8uyFjKn3DotEqYhcZFP36PQX4-hg@mail.gmail.com>
Subject: Re: [PATCH] Lattice ECP3 FPGA: Correct endianness
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, sr@denx.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 5:54 PM, Jean-Michel Hautbois
<jean-michel.hautbois@vodalys.com> wrote:
> --- a/drivers/misc/lattice-ecp3-config.c
> +++ b/drivers/misc/lattice-ecp3-config.c
> @@ -93,7 +93,7 @@ static void firmware_load(const struct firmware *fw,
> void *context)
>      txbuf[0] = FPGA_CMD_READ_ID;
>      ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
>      dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", *(u32 *)&rxbuf[4]);
> -    jedec_id = *(u32 *)&rxbuf[4];
> +    jedec_id = be32_to_cpu(*(u32 *)&rxbuf[4]);

What about "jedec_id = get_unaligned_be32(&rxbuf[4]);" instead?

etc.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
