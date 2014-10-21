Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaJUMeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:34:11 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:36144 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbaJUMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:34:09 -0400
Date: Tue, 21 Oct 2014 13:26:30 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Orson Zhai <orsonzhai@gmail.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>,
        Mark Brown <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        "Geng Ren ( =?UTF-8?B?5Lu76LWT?=)" <geng.ren@spreadtrum.com>,
        "Zhizhou Zhang ( =?UTF-8?B?5byg5rK75rSy?=)" 
	<zhizhou.zhang@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sprdlinux <sprdlinux@freelists.org>
Subject: Re: [PATCH v2 5/5] tty/serial: Add earlycon support for Spreadtrum
 serial driver
Message-ID: <20141021132630.79ce15ba@alan.etchedpixels.co.uk>
In-Reply-To: <CA+H2tpH2dKFHxHUaGtr-vEqxZDtQ_MVTmQTnu5kn-zzUFyXk4Q@mail.gmail.com>
References: <1413539665-11484-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1413539665-11484-6-git-send-email-chunyan.zhang@spreadtrum.com>
	<20141018220615.33643542@alan.etchedpixels.co.uk>
	<CA+H2tpH2dKFHxHUaGtr-vEqxZDtQ_MVTmQTnu5kn-zzUFyXk4Q@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 18:23:38 +0800
Orson Zhai <orsonzhai@gmail.com> wrote:

> On Sun, Oct 19, 2014 at 5:06 AM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
> > On Fri, 17 Oct 2014 17:54:25 +0800
> > Chunyan Zhang <chunyan.zhang@spreadtrum.com> wrote:
> >
> >> Add serial driver for spreadtrum sharkl platform with earlycon
> >> support at first.
> >
> >> +#define UART_TXD     0x0000
> >> +#define UART_RXD     0x0004
> >> +#define UART_STS0    0x0008
> >> +#define UART_STS1    0x000C
> >> +#define UART_IEN     0x0010
> >> +#define UART_ICLR    0x0014
> >> +#define UART_CTL0    0x0018
> >> +#define UART_CTL1    0x001C
> >> +#define UART_CTL2    0x0020
> >> +#define UART_CLKD0   0x0024
> >> +#define UART_CLKD1   0x0028
> >> +#define UART_STS2    0x002C
> >> +
> >> +/*line status */
> >> +#define UART_LSR_TX_OVER     (0x1<<15)
> >
> > Given we use UART_ for all the 8250 defines it might be better to use
> > something else - SHARK_LSR_TX_OVER etc to avoid future confusion
> >
> 
> Does it matter if those macro are only used in the specific c file?
> >From my point of  view, private register macro could be treated as
> static definitions like static variable or functions in C file.
> I also noted that many people use a prefix for the other
> manufacturers' macro definition in source file .
> I have no intention to break the habit of kernel but just for discussion.

Your problem is this. In the kernel headers are definitions like

include/uapi/linux/serial_reg.h:#define UART_TX 0	/* Out: Transmit
buffer */

you are adding identical (but conflicting in places) defines. If some
random change in the include files causes serial_reg.h to be included by
a header you include then it will break.

In addition people habitually use tools like LXR to figure out where
defines and functions are. Having these conflicting definitions will
cause confusion. Better they have prefixes.

Alan

