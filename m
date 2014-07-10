Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaGJKdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:33:23 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:37764 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaGJKdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:33:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdU2HyCwXBJTAyswyj7XqhzhHQ24MamGLLVgMwU4xi0kxQ@mail.gmail.com>
References: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
	<1404982207-4707-2-git-send-email-harinik@xilinx.com>
	<CAMuHMdXO-PkQ+07F=aZEjvH1Kh7uhWK8i3V9w+1aHvvtg7wDoQ@mail.gmail.com>
	<CAFcVECJ93Lw1MRVU-=zLRbB6To--zmAxz8OLObu=mhV84-FTNA@mail.gmail.com>
	<CAMuHMdU2HyCwXBJTAyswyj7XqhzhHQ24MamGLLVgMwU4xi0kxQ@mail.gmail.com>
Date: Thu, 10 Jul 2014 16:03:19 +0530
Message-ID: <CAFcVEC+-bM91WmfwweDdTvJ7KwH+dxKDLkzsT82snWKhukLeYQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, Sourav Poddar <sourav.poddar@ti.com>,
        "michals@xilinx.com" <michals@xilinx.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Thu, Jul 10, 2014 at 3:12 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Harini,
>
> On Thu, Jul 10, 2014 at 11:31 AM, Harini Katakam
> <harinikatakamlinux@gmail.com> wrote:
>>>> +       master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL | SPI_RX_QUAD |
>>>> +                           SPI_TX_DUAL | SPI_TX_QUAD;
>>>
>>> Your driver advertises Dual/Quad SPI Transfer capabilities, but it doesn't
>>> check spi_transfer.[tr]x_nbits? How can it determine when to enable Dual/Quad?
>>
>> Here the driver is just giving information that the controller support it.
>> The MTD layer enables dual/quad based on what the flash supports; quad
>> being the first priority
>> I understand that the spi core reads rx, tx-bus-width property and
>> master support flags and
>> performs the necessary checks.
>
> That's correct: as long as the rx, tx-bus-width  properties do not indicate a
> Dual or Quad wiring, it won't be used.
>
> However, based on schematics, someone may set the rx, tx-bus-width properties
> to 4, which is correct, as DT describes the hardware. But this will fail to
> work.
> So I think it's safer not to announce Dual/Quad support in the driver until
> the actual driver support is there.
>

OK. Correct me if I'm wrong but announcing this support in master->flags is
just to say the controller supports it - Like Punnaiah mentioned in the other
mail, nothing specific needs to be done from the controller driver to enable
dual/quad support. This is at the SOC/IP level.
I agree it might or might not be supported at board-level.
But that's based on the user's hardware. Should master->flags
really take this into consideration?

BTW, I dint see master->mode_bits being used anywhere at the moment.

Regards,
Harini
