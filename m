Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaI2NeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:34:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56521 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaI2NeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:34:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140929132712.GD13142@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
	<1410377411-26656-7-git-send-email-bigeasy@linutronix.de>
	<20140929093823.GD13952@ci00147.xsens-tech.local>
	<20140929132712.GD13142@linutronix.de>
Date: Mon, 29 Sep 2014 15:34:12 +0200
Message-ID: <CAH6sp9Psot-KETANLvH6dw+dWJcpD_hQOgoY1jYZ=riH2kW_qA@mail.gmail.com>
Subject: Re: [PATCH 06/16] tty: serial: Add 8250-core based omap driver
From: Frans Klaver <fransklaver@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Frans Klaver <frans.klaver@xsens.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, linux-serial@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 3:27 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> * Frans Klaver | 2014-09-29 11:38:23 [+0200]:
>
>>threshold
> fixed
>
>>> +    /*
>>> +     * It claims to be 16C750 compatible however it is a little different.
>>> +     * It has EFR and has no FCR7_64byte bit. The AFE (which it claims to
>>> +     * have) is enabled via EFR instead of MCR. The type is set here 8250
>>> +     * just to get things going. UNKNOWN does not work for a few reasons and
>>> +     * we don't need our own type since we don't use 8250's set_termios()
>>> +     * and our "bugs" are handeld via the bug member.
>>
>>handled
> replaced that last line with
>     or pm callback.
>
> since there no bugs member anymore.
>
>>
>>> +     */
>>> +    up.port.type = PORT_8250;
>>> +    up.port.iotype = UPIO_MEM;
>>> +    up.port.flags = UPF_FIXED_PORT | UPF_FIXED_TYPE | UPF_SOFT_FLOW |
>>> +            UPF_HARD_FLOW;
>>> +    up.port.private_data = priv;
>>> +
>>> +    up.port.regshift = 2;
>>> +    up.port.fifosize = 64;
>>> +    up.tx_loadsz = 64;
>>> +    up.capabilities = UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP;
>>> +#ifdef CONFIG_PM_RUNTIME
>>> +    /*
>>> +     * PM_RUNTIME is mostly transparent. However to do it right we need to a
>>
>>need to _do_ a ...?
> I think dropping that 'to' should fix it.

Yup.

>
>>> +     * TX empty interrupt before we can put the device to auto idle. So if
>>> +     * PM_RUNTIME is not enabled we don't add that flag and can spare that
>>> +     * one extra interrupt in the TX path.
>>> +     */
>>
>><snip>
>>
>>> +config SERIAL_8250_OMAP
>>> +    tristate "Support for OMAP internal UART (8250 based driver)"
>>> +    depends on SERIAL_8250 && ARCH_OMAP2PLUS
>>> +    help
>>> +      If you have a machine based on an Texas Instruments OMAP CPU you
>>> +      can enable its onboard serial ports by enabling this option.
>>> +
>>> +      This driver is in early stage and uses ttyS instead of ttyO.
>>> +
>>
>>I just wondered if this driver should be marked experimental?
> What did you have in mind? CONFIG_EXPERIMENTAL is gone. After all that
> debuging that I had in the meantime I was thinking about dropping that
> "early stage".

That was the other option. I'm good with that. Also, I never noticed
CONFIG_EXPERIMENTAL being gone, so that's down the drain ;).

>
>>Thanks,
>>Frans
>
> Sebastian
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
