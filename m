Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbaI2QPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:15:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:52824 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaI2QPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:15:08 -0400
Date: Mon, 29 Sep 2014 18:15:05 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140929161505.GF13142@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <1410377411-26656-10-git-send-email-bigeasy@linutronix.de>
 <20140911111721.GB17476@xps8300>
 <54118AAB.2010205@linutronix.de>
 <5411967A.6090406@hurleysoftware.com>
 <54119AAA.9080907@linutronix.de>
 <5411B33F.10405@hurleysoftware.com>
 <54171B85.5060209@linutronix.de>
 <54186B89.8050505@linutronix.de>
 <54197C99.8030601@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <54197C99.8030601@hurleysoftware.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Hurley | 2014-09-17 08:20:41 [-0400]:

>> So I connected my am335x-evm
>> with beagle board xm because both of them have an old fashion UART
>> connector (instead those uart-to-usb). Both configured with HW-Flow and
>> I haven't seen the function invoked but I saw "port->icount.overrun"
>> being incremented. This shouldn't happen. So I am a little puzzled here…
>
>Yeah, that's weird. Do you have a break-out box to confirm that RTS/CTS are
>being driven?

=>
- beagle board
  According to schematics the board has only RX and TX connected. No
  RTS/CTS

- am335x-evm
  The schematics say "DNI" next to a resistor on RTS/CTS. DNI stands
  most likely for "Do Not Install". With a scope it looks like the the
  wire behind the MAX is open.

- beagle bone black
  Only RX and TX are wired towards the USB2serial device.

In short: each device I have has RTS/CTS not working/connected and I
can't test HW handshake with HW available.

>Regards,
>Peter Hurley

Sebastian
