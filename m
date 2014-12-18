Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaLRJN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:13:27 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:64922 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaLRJNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:13:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        YH Chen =?utf-8?B?KOmZs+aYseixqik=?= <yh.chen@mediatek.com>
Subject: Re: [PATCH 1/2] tty: serial: 8250_mtk: Add earlycon
Date: Thu, 18 Dec 2014 10:12:33 +0100
Message-ID: <1822504.xkcBG8sz41@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CABuKBe+dki5ab8PexMhq36AJFCBk_dBifV86F8FKsF_es1cmJA@mail.gmail.com>
References: <1418891601-53769-1-git-send-email-eddie.huang@mediatek.com> <1418891601-53769-2-git-send-email-eddie.huang@mediatek.com> <CABuKBe+dki5ab8PexMhq36AJFCBk_dBifV86F8FKsF_es1cmJA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:DOiE1OoYx1vxN1BfsrLyAZHLmxL6NzD5TyhGXmNlF7bhtSrXlIE
 1c1SnVfSbZrw13nbTRnZScxWf8xx9bA4PJT8qmakTh2z0hgHLhV2RdrnOVz8Qu5rP0z+oSL
 68Y/qLcHqwv6FHLlvfdXuZVFv1rgua4YUxxSjIMCEHB+u79WXSxg9Mzjd6Y1Yc1fp6j2/dE
 hLOmjUfmH5g7ruoNSjpuA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2014 09:48:31 Matthias Brugger wrote:
> > +static void __init mtk8250_serial_putc(struct uart_port *port, int c)
> > +{
> > +       while ((readl(port->membase + (UART_LSR << 2)) & BOTH_EMPTY) !=
> > +               BOTH_EMPTY)
> > +               ;
> 
> Please delete newline before the semicolon.
> 

No, that newline is best kept in there for clarity. An even better way
to write this would be using cpu_relax():

	while ((readl(port->membase + (UART_LSR << 2)) & BOTH_EMPTY) != BOTH_EMPTY)
		cpu_relax();

which the kernel convention for doing busy-loops.

	Arnd
