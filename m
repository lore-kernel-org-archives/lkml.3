Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbaK0M6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:58:38 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:56050 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaK0M6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:58:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lyra Zhang <zhang.lyra@gmail.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        Grant Likely <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        Will Deacon <will.deacon@arm.com>, gnomes@lxorguk.ukuu.org.uk,
        Jonathan Corbet <corbet@lwn.net>, jason@lakedaemon.net,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        florian.vaussard@epfl.ch, andrew@lunn.ch,
        Hayato Suzuki <hytszk@gmail.com>, Orson Zhai <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        lanqing.liu@spreadtrum.com,
        Wei Qiao =?utf-8?B?KOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Thu, 27 Nov 2014 13:57:57 +0100
Message-ID: <3400511.2SONqVcoEr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAfSe-uMqy7zwiEK+nDoMPw_oni8L_vq7oW2Me5AY8z8KGpjwQ@mail.gmail.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com> <54761BFC.4020705@ti.com> <CAAfSe-uMqy7zwiEK+nDoMPw_oni8L_vq7oW2Me5AY8z8KGpjwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yX41ekMzObZLMbydS0mjdMR32HQ7cJEnWABvkfVF/AL
 UvvUb3XVzT1nr+edvPd1+c/XIHTfkxvI+WoJf1QfoZvTPvdXwR
 +OGxeQRgOYuzzU6Tk1bBMYUrNBh+ioidJ0HtK92J6rMVxu94I4
 8+fVryFFqX3NAFi1gfT/z/craG5WyTvJdbh2ylUL+gjhG2NYfO
 1lGM83FIP6Rg2Ukx148P3rNd5UlBhEekmY8veHaYmjN95EgLvE
 ldySWZRHEcwYUyFulWtDj3tT4VXIKGjMzm/DvAdrEGyi8pewLq
 sbp6ZIOYpFH3N5G0SjabS065wD1kqtlZctGtUShKuRCvZE9xbl
 t45KjsLKnkdGTBh9IAWc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 19:59:46 Lyra Zhang wrote:
> 2014-11-27 2:29 GMT+08:00 Murali Karicheri <m-karicheri2@ti.com>:
> > On 11/25/2014 07:16 AM, Chunyan Zhang wrote:
> >>
> >> Add a full sc9836-uart driver for SC9836 SoC which is based on the
> 
> >> +#include<linux/clk.h>
> >
> > How about sorting this includes? asm/irq.h go first followed linux/ in
> > alphabatical order?
> 
> >> +static irqreturn_t sprd_handle_irq(int irq, void *dev_id)
> >> +{
> >> +       struct uart_port *port = (struct uart_port *)dev_id;
> >> +       u32 ims;
> >> +
> >> +       ims = serial_in(port, SPRD_IMSR);
> >> +
> >> +       serial_out(port, SPRD_ICLR, ~0);
> >> +
> >> +       if (ims&  (SPRD_IMSR_RX_FIFO_FULL |
> >> +               SPRD_IMSR_BREAK_DETECT | SPRD_IMSR_TIMEOUT)) {
> >> +               sprd_rx(irq, port);
> >> +       }
> >> +       if (ims&  SPRD_IMSR_TX_FIFO_EMPTY)
> >> +               sprd_tx(irq, port);
> >> +
> >> +       return IRQ_HANDLED;
> >
> > You are always returning IRQ_HANDLED and this is registered as a SHARED irq.
> > Is there a chance this handler is called and the irq event doesn't
> > belong to this device?
> >
> > Murali
> 
> You are right, this is not a SHARED irq. I'll pass 0 for irqflags when
> called 'devm_request_irq' in the next version patch.

I think you could also add

	if (!ims)
		return IRQ_NONE;

which would make it work on shared interrupt lines.

	Arnd
