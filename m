Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaIXHyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:54:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:51982 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaIXHx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:53:58 -0400
Date: Wed, 24 Sep 2014 09:53:46 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Frans Klaver <frans.klaver@xsens.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140924075346.GB19565@linutronix.de>
References: <5411C810.7070906@linutronix.de>
 <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com>
 <54129F6C.7040508@linutronix.de>
 <20140912094010.GE28458@ci00147.xsens-tech.local>
 <5412C21A.8020203@linutronix.de>
 <20140912102816.GF28458@ci00147.xsens-tech.local>
 <541716DC.9020904@linutronix.de>
 <20140917102812.GA20438@ci00147.xsens-tech.local>
 <20140921204100.GA10111@linutronix.de>
 <5421A7F7.3070109@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5421A7F7.3070109@hurleysoftware.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Hurley | 2014-09-23 13:03:51 [-0400]:

>readline() does this; it 'saves' the caller's termios, sets termios
>for non-canonical reads, reads one char, and 'restores' the caller's
>termios.

interresting, thanks. I guess I would need to opimize this a little so
the baudrate isn't going to 0 and back to the requested baudrate.

>The tty core calls the driver's wait_until_sent() method before changing
>the termios (if TCSADRAIN is used for tcsetattr(), which I think for readline()
>it does).

The interresting difference is that when I take the yocto RFS and chroot
into from Debian then I don't this problem. Not sure if this is really
readline or something else…

>But DMA is cheating if the UART driver's tx_empty() method is saying the
>transmitter is empty while TX DMA is still running.
This shouldn't be the case. But I will check this once I able to.
After TX-DMA is done, "xmit->tail" is updated and port.icount.tx is
incremented. At this time the TX FIFO is still full (up to 64 bytes) and
I set UART_IER_THRI to wait until TX FIFO is empty so I can disable
runtime-pm. Therefore I would assume LSR does not say BOTH_EMPTY until
the FIFO is empty.

>Regards,
>Peter Hurley

Sebastian
