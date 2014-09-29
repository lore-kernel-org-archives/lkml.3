Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaI2Jid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:38:33 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:60669 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaI2Jib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:38:31 -0400
X-ASG-Debug-ID: 1411983505-0759e74bdc52eec0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Mon, 29 Sep 2014 11:38:23 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-serial@vger.kernel.org>, <tony@atomide.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/16] tty: serial: Add 8250-core based omap driver
Message-ID: <20140929093823.GD13952@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 06/16] tty: serial: Add 8250-core based omap driver
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <1410377411-26656-7-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1410377411-26656-7-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411983505
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10016
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:30:01PM +0200, Sebastian Andrzej Siewior wrote:
> +	/*
> +	 * We enable TRIG_GRANU for RX and TX and additionaly we set
> +	 * SCR_TX_EMPTY bit. The result is the following:
> +	 * - RX_TRIGGER amount of bytes in the FIFO will cause an interrupt.
> +	 * - less than RX_TRIGGER number of bytes will also cause an interrupt
> +	 *   once the UART decides that there no new bytes arriving.
> +	 * - Once THRE is enabled, the interrupt will be fired once the FIFO is
> +	 *   empty - the trigger level is ignored here.
> +	 *
> +	 * Once DMA is enabled:
> +	 * - UART will assert the TX DMA line once there is room for TX_TRIGGER
> +	 *   bytes in the TX FIFO. On each assert the DMA engine will move
> +	 *   TX_TRIGGER bytes into the FIFO.
> +	 * - UART will assert the RX DMA line once there are RX_TRIGGER bytes in
> +	 *   the FIFO and move RX_TRIGGER bytes.
> +	 * This is because treshold and trigger values are the same.

threshold

> +	/*
> +	 * It claims to be 16C750 compatible however it is a little different.
> +	 * It has EFR and has no FCR7_64byte bit. The AFE (which it claims to
> +	 * have) is enabled via EFR instead of MCR. The type is set here 8250
> +	 * just to get things going. UNKNOWN does not work for a few reasons and
> +	 * we don't need our own type since we don't use 8250's set_termios()
> +	 * and our "bugs" are handeld via the bug member.

handled

> +	 */
> +	up.port.type = PORT_8250;
> +	up.port.iotype = UPIO_MEM;
> +	up.port.flags = UPF_FIXED_PORT | UPF_FIXED_TYPE | UPF_SOFT_FLOW |
> +		UPF_HARD_FLOW;
> +	up.port.private_data = priv;
> +
> +	up.port.regshift = 2;
> +	up.port.fifosize = 64;
> +	up.tx_loadsz = 64;
> +	up.capabilities = UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP;
> +#ifdef CONFIG_PM_RUNTIME
> +	/*
> +	 * PM_RUNTIME is mostly transparent. However to do it right we need to a

need to _do_ a ...?

> +	 * TX empty interrupt before we can put the device to auto idle. So if
> +	 * PM_RUNTIME is not enabled we don't add that flag and can spare that
> +	 * one extra interrupt in the TX path.
> +	 */

<snip>

> +config SERIAL_8250_OMAP
> +	tristate "Support for OMAP internal UART (8250 based driver)"
> +	depends on SERIAL_8250 && ARCH_OMAP2PLUS
> +	help
> +	  If you have a machine based on an Texas Instruments OMAP CPU you
> +	  can enable its onboard serial ports by enabling this option.
> +
> +	  This driver is in early stage and uses ttyS instead of ttyO.
> +

I just wondered if this driver should be marked experimental?


Thanks,
Frans
