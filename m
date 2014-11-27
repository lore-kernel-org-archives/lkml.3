Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaK0Pis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:38:48 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:60656 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaK0Pio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:38:44 -0500
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
        Will Deacon <will.deacon@arm.com>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>, Hayato Suzuki <hytszk@gmail.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        Wei Qiao =?utf-8?B?KOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Thu, 27 Nov 2014 16:36:52 +0100
Message-ID: <7773522.25QE5ibXJZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAfSe-uWvn4MX-+GKuvvd=G2MTfLDCFeLRoUGWp7vvc81wfu0w@mail.gmail.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com> <3400511.2SONqVcoEr@wuerfel> <CAAfSe-uWvn4MX-+GKuvvd=G2MTfLDCFeLRoUGWp7vvc81wfu0w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bvTw+6pTwh8/KAmydKQi86OZGnRtMC58kkzw24WL2XE
 +Vud2x7FJDzZdAC5dP/n3VtRfaEUd+GxPRilFiwWuKc4dneGvq
 MVwRnq3Fs5rWJ6QoC9aanFdO8X2yJC1tH7cIo3ummb8iB1yk8l
 rmWo7fz7Unt4nU6vgxcWgLGZ2MOtgtjI8/nS2L3eYQdlUYBsLr
 eZH3f1liWV9OQK8F2AvrPYyS3oXIa+RMrENb7ZNwrmybdLblZ+
 4ndj7sDUpMC1tspBUNtDMLGJEiVDZ/IR8Zu6BuYrdNFtF8NeFN
 t+dVVMwG+NwaAlhoU8v85C9MYQagz0Fy8thxdN/J4vuo8PBaht
 9KdNQId0CBTgEKn2b1nc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 23:23:17 Lyra Zhang wrote:
> 
> Yes, I saw this way in other serial drivers.
> But, if then, there are two questions for me:
> 1. Why did some serial drivers need an UN_SHARED irq?

A lot of drivers were written before we had shared IRQs, or
were copied from old drivers, or are for hardware that uses
edge-triggered interrupts instead of level-triggered interrupts.

Only level-triggered interrupts can be shared.

> 2. How can we choose a right way?

It never hurts to implement a shared interrupt handler. Only
if you have no way to find out whether the device triggered
the interrupt or not you have to leave out IRQF_SHARED, and then
you won't be able to return IRQ_NONE.

	Arnd
