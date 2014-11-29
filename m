Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaK2A4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 19:56:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56686 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751324AbaK2A4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 19:56:01 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        USB development list <linux-usb@vger.kernel.org>
Subject: Re: [Update][PATCH] USB / PM: Drop CONFIG_PM_RUNTIME from the USB core
Date: Sat, 29 Nov 2014 02:17:18 +0100
Message-ID: <2562941.6pSKsRYOqk@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1411281102170.29147-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1411281102170.29147-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 28, 2014 11:09:11 AM Alan Stern wrote:
> On Fri, 28 Nov 2014, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: USB / PM: Drop CONFIG_PM_RUNTIME from the USB core
> > 
> > After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> > selected) PM_RUNTIME is always set if PM is set, so quite a few
> > #ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
> > depend on CONFIG_PM (or even dropped in some cases).
> > 
> > Replace CONFIG_PM_RUNTIME with CONFIG_PM in the USB core code
> > and ABI documentation.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> > 
> > Added headers and two ABI documentation files, plus one missing instance in
> > drivers/usb/core/hcd.c.
> > 
> > Of course, this depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME
> > if PM_SLEEP is selected) which is in linux-next only (via linux-pm) at the
> > moment.
> 
> There are also one or two places in Documentation/usb that mention 
> CONFIG_PM_RUNTIME.

I found this in Documentation/usb/power-management.txt:

"Note: Dynamic PM support for USB is present only if the kernel was
 built with CONFIG_USB_SUSPEND enabled (which depends on
 CONFIG_PM_RUNTIME).  System PM support is present only if the kernel
 was built with CONFIG_SUSPEND or CONFIG_HIBERNATION enabled.

 (Starting with the 3.10 kernel release, dynamic PM support for USB is
 present whenever the kernel was built with CONFIG_PM_RUNTIME enabled.
 The CONFIG_USB_SUSPEND option has been eliminated.)"

but I'm quite unsure how to change it.  What about:

"System PM support is present only if the kernel was built with CONFIG_SUSPEND
 or CONFIG_HIBERNATION enabled.  Dynamic PM support for USB is present whenever
 the kernel was built with CONFIG_PM enabled.

 [Historically, dynamic PM support for USB was present only if the kernel
 had been built with CONFIG_USB_SUSPEND enabled (which depended on
 CONFIG_PM_RUNTIME).  Starting with the 3.10 kernel release, dynamic PM support
 for USB was present whenever the kernel was built with CONFIG_PM_RUNTIME
 enabled.  The CONFIG_USB_SUSPEND option had been eliminated.]

Rafael

