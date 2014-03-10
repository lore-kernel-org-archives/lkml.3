Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaCJTQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:16:29 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43434 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaCJTQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:16:26 -0400
MIME-Version: 1.0
In-Reply-To: <1469359.kil5iaOqdU@wuerfel>
References: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com>
	<2115856.ZTdgp5fkma@wuerfel>
	<20140310163343.GY6457@e106497-lin.cambridge.arm.com>
	<1469359.kil5iaOqdU@wuerfel>
Date: Mon, 10 Mar 2014 20:16:25 +0100
X-Google-Sender-Auth: 4e79h_NW-G1WmKoFxDZPXl6U_4c
Message-ID: <CAMuHMdWzm1D83zquwuQVKwbqRdXmSw7u1ui7iZyC3VGdGhn0HA@mail.gmail.com>
Subject: Re: [PATCH v6 6/6] pci: Add support for creating a generic
 host_bridge from device tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 7:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> arch/avr32/include/asm/io.h:#define IO_SPACE_LIMIT    0xffffffff
>> arch/frv/include/asm/io.h:#define IO_SPACE_LIMIT      0xffffffff
>
> They have no MMU, and the code relies on the port number to match
> both the virtual and the physical address. You could be right about
> these, but I would guess that the code also needs some other
> changes if we want to make it work on nommu kernels. It also depends
> on whether the I/O bus address is the same as the CPU address, or
> if it starts at bus address 0.

>> arch/m68k/include/asm/io_no.h:#define IO_SPACE_LIMIT 0xffffffff
>
> This looks like a mistake, it should be smaller

io_no.h is for nommu.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
