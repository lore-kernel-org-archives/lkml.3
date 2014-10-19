Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaJSTwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 15:52:09 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:63650 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaJSTv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 15:51:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Belisko <marek@goldelico.com>
Cc: gregkh@linuxfoundation.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>, "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH 1/2] misc: Add Wi2Wi w2sc0004 gps driver
Date: Sun, 19 Oct 2014 21:51:27 +0200
Message-ID: <9266107.dnSTmzxRsf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413491183-15018-1-git-send-email-marek@goldelico.com>
References: <1413491183-15018-1-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:I1bXDxYTiYq7FvxzMzLgkZoa+ZLDkTKUGCS+FSDA71r
 5+2sQ8Vt228WCEnzKmNi5Set/NnitlJMMwUSHKqbjZUBhnl34r
 HB5vw9imQrvldYxf08k66NXbXhNXz9Lbj1iLWxMvtpTcWjjxVE
 mH7GgB2BeoOFGRaKNbcBnC6gjHC1r/DSOZtwf/hDn9x7vzb77A
 dpmYOnWggXfsCq3Km1jhVv1jBpc6vjV0wEj1ZmtcwRkZ+zZtCC
 uT8DrM1MECL0+hoXBOejv28c9cW4DnwXMyZNuhXFPyeRLRCRXG
 D1kRGh+63Xtb0Y3zzNP56cVri2vC4b9yuNglThto8y+ybAe/RF
 Od2EQegtNjTFzz70+www=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2014 22:26:22 Marek Belisko wrote:
> This is a driver for the Wi2Wi GPS modules connected through an UART.
> The tricky part is that the module is turned on or off by an impulse
> on the control line - but it is only possible to get the real state by monitoring
> the UART RX input. Since the kernel can't know in which status the module
> is brought e.g. by a boot loader or after suspend, we need some logic to handle
> this.
> 
> The driver allows two different methods to enable (and power up) GPS:
> a) through rfkill
> b) as a GPIO
> 
> The GPIO enable can be plumbed to other drivers that expect to be able to control
> a GPIO. On the GTA04 board this is the DTR-gpio of the connected UART so that
> opening the UART device enables the receiver and closing it shuts the receiver down.
> 
> Original implementation by Neil Brown, fixes + DT bindings by H. Nikolaus Schaller

I'm not sure if this is a good way to model the device. You say that it's
connected to a UART, but the code itself has no reference to the tty layer
at all. I assume the actual driver is in user space and it would open the
UART and this control device as separate instances handles and then try
to coordinate them. Is that right?

What is the protocol for the GPS driver itself? Is it standardized?
Would it help to have a TTY line discipline for the GPS mode instead
so the power management and startup could be integrated into the serial
port management instead?

	Arnd
