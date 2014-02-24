Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaBXNYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:24:22 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39359 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaBXNYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:24:20 -0500
Date: Mon, 24 Feb 2014 13:23:34 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: locking changes in tty broke low latency feature
Message-ID: <20140224132334.313f2527@alan.etchedpixels.co.uk>
In-Reply-To: <alpine.DEB.2.02.1402232330190.21251@ionos.tec.linutronix.de>
References: <20140219230623.736E8406062@ip-64-139-1-69.sjc.megapath.net>
	<53056E99.9070900@hurleysoftware.com>
	<53064672.3000807@hurleysoftware.com>
	<alpine.DEB.2.02.1402232330190.21251@ionos.tec.linutronix.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a complete pointless test. Use a bog standard 8250 UART on the
> PC and connect a microcontroller on the other end which serves you an
> continous stream of data at 115200 Baud.
> 
> There is no way you can keep up with that without the low latency
> option neither on old and nor on new machines if you have enough other
> stuff going on in the system.

Sorry but having done this in the past the reverse is true. On ancient
machines with crap uarts the low_latency case would routinely overrun
while the non low_latency case did not. That was half of the point of
deferred processing - it pushed tty processing out of the IRQ handler so
bytes were not lost and a 486DX could cope with a 56Kbit modem.

Alan
