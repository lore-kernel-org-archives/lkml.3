Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbaGDNLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:11:45 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:39555 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbaGDNLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:11:43 -0400
MIME-Version: 1.0
In-Reply-To: <1404403920.14741.44.camel@joe-AO725>
References: <CAL8zT=isq_2RT07a6z8imJ4N0w0v-yw6ysv3wf+S7sLsqZBCeg@mail.gmail.com>
	<1404403920.14741.44.camel@joe-AO725>
Date: Fri, 4 Jul 2014 15:11:42 +0200
Message-ID: <CAPwkgkOjr6y2M8FMytx6Ooz_LJwUtDckU1Q2piuV0mR0vOnD1w@mail.gmail.com>
Subject: Re: [PATCH] Lattice ECP3 FPGA: Correct endianness
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, sr@denx.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-03 18:12 GMT+02:00 Joe Perches <joe@perches.com>:
>
> On Thu, 2014-07-03 at 17:54 +0200, Jean-Michel Hautbois wrote:
> > This patch corrects three big/little endian issues. Tested on i.MX6.
>
> trivial:
>
> > diff --git a/drivers/misc/lattice-ecp3-config.c
> []
> > @@ -165,8 +165,8 @@ static void firmware_load(const struct firmware
> > *fw, void *context)
> >
> >      txbuf[0] = FPGA_CMD_READ_STATUS;
> >      ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
> > -    dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
> > -    status = *(u32 *)&rxbuf[4];
> > +    dev_dbg(&spi->dev, "FPGA Status=%08x\n", be32_to_cpu(*(u32 *)&rxbuf[4]));
> > +    status = be32_to_cpu(*(u32 *)&rxbuf[4]);
>
> This should emit a sparse error.
> It'd be simpler as:
>
>         status = be32_to_cpu(*(__be32 *)&rxbuf[4]);
>         dev_dbg(&spi->dev, "FPGA Status=%08x\n", status);
>
>

OK, do you want me to send a new patch including this modification ?


JM
