Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbaGDPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 11:16:56 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:43518 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaGDPQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 11:16:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXBpgfVuvpW8gq2XY8uyFjKn3DotEqYhcZFP36PQX4-hg@mail.gmail.com>
References: <CAL8zT=isq_2RT07a6z8imJ4N0w0v-yw6ysv3wf+S7sLsqZBCeg@mail.gmail.com>
 <CAMuHMdXBpgfVuvpW8gq2XY8uyFjKn3DotEqYhcZFP36PQX4-hg@mail.gmail.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Fri, 4 Jul 2014 17:16:39 +0200
X-Google-Sender-Auth: txOz081Ouj0FwlLmF2idKgIhv-Y
Message-ID: <CAL8zT=hVhtZ7SPguhpYY22hTLaao4ZpwG3HWV3F3SR5mO4mw-w@mail.gmail.com>
Subject: Re: [PATCH] Lattice ECP3 FPGA: Correct endianness
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Stefan Roese <sr@denx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-04 16:58 GMT+02:00 Geert Uytterhoeven <geert@linux-m68k.org>:
> On Thu, Jul 3, 2014 at 5:54 PM, Jean-Michel Hautbois
> <jean-michel.hautbois@vodalys.com> wrote:
>> --- a/drivers/misc/lattice-ecp3-config.c
>> +++ b/drivers/misc/lattice-ecp3-config.c
>> @@ -93,7 +93,7 @@ static void firmware_load(const struct firmware *fw,
>> void *context)
>>      txbuf[0] = FPGA_CMD_READ_ID;
>>      ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
>>      dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", *(u32 *)&rxbuf[4]);
>> -    jedec_id = *(u32 *)&rxbuf[4];
>> +    jedec_id = be32_to_cpu(*(u32 *)&rxbuf[4]);
>
> What about "jedec_id = get_unaligned_be32(&rxbuf[4]);" instead?

Eh I didn't know such a function existed ! :)

JM
