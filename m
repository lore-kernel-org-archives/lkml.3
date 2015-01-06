Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbbAFNOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:14:49 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:53517 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbbAFNOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:14:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] serial: 8250: Make ISA ports optional
Date: Tue, 06 Jan 2015 14:13:59 +0100
Message-ID: <9492211.AECobr3jIN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420513785-23660-1-git-send-email-peter@hurleysoftware.com>
References: <1420513785-23660-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:zE+GjIDfhNXIPzkwiamIRKvdUmQHNaxB+OxFbJ/DY5gCnEL70sp
 2DYWugB+kMbaeBV/ERV2v1nS5hhlPfXUuIGGAtXugScJQxsLhZslcmPEQwN8LIGKg9hMJGV
 pdOtgs63pZjKJBoDJqNihGnqQQsmuIUMkQOjmnyRGa0Xmx84Rw2h/9tIjK0msDiqyskHoIk
 4bJdxvq5vnqReuV9eVEJQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2015 22:09:45 Peter Hurley wrote:
> Some arches have no need to create unprobed 8250 ports; these phantom
> ports are primarily required for ISA ports which have no probe
> mechanism or to provide non-operational ports for userspace to
> configure (via TIOCSSERIAL and TIOCSERCONFIG ioctls).
> 
> Provide CONFIG_SERIAL_8250_PHANTOM_UARTS knob to disable phantom port
> registration; ie., CONFIG_SERIAL_8250_PHANTOM_UARTS=N only registers
> probed ports (ACPI/PNP, "serial8250" platform devices, PCI, etc).
> 
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

The intent is definitely right, but I think a better approach is
possible.

I haven't tried it here, but how about moving the serial8250_init
function into a separate module, along with all the other parts
that are only used for ISA devices, but leaving the actual core
(all exported symbols) in this file?

At the same time, the serial8250_pnp_init/serial8250_pnp_exit calls
can be removed from the serial8250_init function and become
standalone initcalls.

	Arnd
