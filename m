Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3ENHPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:15:43 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59126 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3ENHPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:15:41 -0400
X-AuditID: 9c93017d-b7b62ae000004f69-bc-5191e49bbc0e
From: "Jongsung Kim" <neidhard.kim@lge.com>
To: "'Stephen Warren'" <swarren@wwwdotorg.org>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <007301ce375e$bcf6d6b0$36e48410$@lge.com> <5191D200.3040604@wwwdotorg.org>
In-Reply-To: <5191D200.3040604@wwwdotorg.org>
Subject: RE: [PATCH] ARM: PL011: add support for extended FIFO-size of PL011-r1p5
Date: Tue, 14 May 2013 16:15:39 +0900
Organization: LG Electronics
Message-ID: <01fd01ce5072$d6b9fcd0$842df670$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHInDuhqkp37yHuVjCbmrHEKQdwAwJ2699/mPvokRA=
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> :
> For reference, the AMBA periphid of the UART device there is 0x00341011.
> The nibble "3" is the revision being tested in:

The UART device has periphid 0x00341011, and is compatible with the
original PL011 prior to r1p5. Not with r1p5. It could be a possible
way to specify the compatible periphid (such as 0x00241011) instead
of just 0x0 when initializing the amba_device for the UART.

> > +static unsigned int get_fifosize_arm(unsigned int periphid)
> > +{
> > +	unsigned int rev = (periphid >> 20) & 0xf;
> > +	return rev < 3 ? 16 : 32;
> > +}
>
> Should that be <= not <, or is there just something more wrong in the
> patch or bcm2835 HW? I wonder how r1p5 maps to 3 in the test above.

>From the PL011-r1p5 TRM, bits[7:4] of the UARTPeriphID2 register are
read as:

r1p0 - 0x0
r1p1 - 0x1
r1p3 - 0x2
r1p4 - 0x2
r1p5 - 0x3.

Doesn't the BCM2835 UART have anything different from the ARM PL011?
What about the UARTPCellID registers? They are set to 0xb105f00d with
the ARM PL011.

