Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab3GCQCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:02:47 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:46583 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932369Ab3GCQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:02:46 -0400
Message-ID: <51D44B24.3050407@newflow.co.uk>
Date: Wed, 03 Jul 2013 17:02:44 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: AM335x: is AUTORTS mode supported ?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm struggling to determine if AUTORTS mode is currently supported in 3.10 ?

I have dug into the source code, and can see various references to the relevant bits
in the various UART registers, but I'm at a lose as to how to actually *enable* the
mode !!

In drivers/tty/omap-serial.c serial_omap_set_termios() we have:-

	if (termios->c_cflag & CRTSCTS && up->port.flags & UPF_HARD_FLOW) {
		/* Enable AUTORTS and AUTOCTS */
		up->efr |= UART_EFR_CTS | UART_EFR_RTS;

		/* Ensure MCR RTS is asserted */
		up->mcr |= UART_MCR_RTS;
	} else {
		...
	}

So it looks like I need to set the CRTSCTS and UPF_HARD_FLOW flags.

>From userspace, I've tried:-

$ stty -F /dev/ttyO2 crtscts

But I've not idea how to enable UPF_HARD_FLOW !?!

Can anyone point me in the right direction ?

Cheers
Mark J.
