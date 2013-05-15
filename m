Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab3EOBAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 21:00:14 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50571 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab3EOBAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 21:00:12 -0400
X-AuditID: 9c930179-b7b92ae0000035f7-e9-5192de191652
From: "Jongsung Kim" <neidhard.kim@lge.com>
To: "'Stephen Warren'" <swarren@wwwdotorg.org>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <007301ce375e$bcf6d6b0$36e48410$@lge.com> <5191D200.3040604@wwwdotorg.org> <01fd01ce5072$d6b9fcd0$842df670$@lge.com> <5192A692.4010700@wwwdotorg.org>
In-Reply-To: <5192A692.4010700@wwwdotorg.org>
Subject: RE: [PATCH] ARM: PL011: add support for extended FIFO-size of PL011-r1p5
Date: Wed, 15 May 2013 10:00:07 +0900
Organization: LG Electronics
Message-ID: <022d01ce5107$8bc668e0$a3533aa0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHInDuhqkp37yHuVjCbmrHEKQdwAwJ2699/Ap2LRfIByYWvJZjZ3ksw
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> :
> Looking at BCM2835-ARM-Peripherals.pdf (i.e. the public documentation for
> the BCM2835 chip), I see:
>
> =====
> The UART provides:
> * Separate 16x8 transmit and 16x12 receive FIFO memory.
> ...
> For the in-depth UART overview, please, refer to the ARM PrimeCell UART
> (PL011) Revision: r1p5 Technical Reference Manual.
> =====
>
> That seems to imply that not all r1p5 PL011s actually have a depth-32
FIFO.
> Perhaps this is a configurable property of the IP block, not something
that
> all r1p5 have?

All r1p5 have 32-byte FIFO depth and it's not configurable. From the PL011
TRM:

r1p4-r1p5	Contains the following differences in functionality:
		* The receive and transmit FIFOs are increased to a depth of
32.
		* The Revision field in the UARTPeriphID2 Register on page
3-24
		  bits [7:4] now reads back as 0x3.

