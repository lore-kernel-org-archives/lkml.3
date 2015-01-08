Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbbAHNLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:11:55 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:36547 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbbAHNLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:11:39 -0500
Date: Thu, 8 Jan 2015 13:10:08 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] serial: 8250: Make ISA ports optional
Message-ID: <20150108131008.16c9a31c@lxorguk.ukuu.org.uk>
In-Reply-To: <1420513785-23660-1-git-send-email-peter@hurleysoftware.com>
References: <1420513785-23660-1-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Jan 2015 22:09:45 -0500
Peter Hurley <peter@hurleysoftware.com> wrote:

> Some arches have no need to create unprobed 8250 ports; these phantom
> ports are primarily required for ISA ports which have no probe
> mechanism or to provide non-operational ports for userspace to
> configure (via TIOCSSERIAL and TIOCSERCONFIG ioctls).
> 
> Provide CONFIG_SERIAL_8250_PHANTOM_UARTS knob to disable phantom port
> registration; ie., CONFIG_SERIAL_8250_PHANTOM_UARTS=N only registers
> probed ports (ACPI/PNP, "serial8250" platform devices, PCI, etc).

Just #define serial8250_isa_devs to 0 on such platforms. gcc should then
be bright enough to do the rest for you.

