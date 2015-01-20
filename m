Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbbATVra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:47:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbbATVr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:47:28 -0500
Message-ID: <1421790436.1112.14.camel@linux-0dmf.site>
Subject: Re: USB autosuspend causing trouble with bluetooth
From: Oliver Neukum <oneukum@suse.de>
To: Kirill Elagin <kirelagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Tue, 20 Jan 2015 22:47:16 +0100
In-Reply-To: <CABVT_geh3RjaG+zX6xUWL9RQtwoAeyuC33xf2vT2o0HPPkokcg@mail.gmail.com>
References: <CABVT_gf-rx0ymvtCrCotkO5=qoDifG1yAMg8U_aTgXEN=x6gvg@mail.gmail.com>
	 <1421751814.29486.13.camel@linux-0dmf.site>
	 <CABVT_gcqjp1V6vnOOSewYYeR2PmngAQhuR+fud=bDU6FJ8Bnqw@mail.gmail.com>
	 <1421762788.29486.28.camel@linux-0dmf.site>
	 <CABVT_gdCvbK8mUQMjDmiAmc_6kbBUMf4XFeAZ=zzjOYS+7oCGg@mail.gmail.com>
	 <1421775689.1112.4.camel@linux-0dmf.site>
	 <CABVT_geh3RjaG+zX6xUWL9RQtwoAeyuC33xf2vT2o0HPPkokcg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 23:25 +0400, Kirill Elagin wrote:

> Hm, I'm pretty sure I never touched anything with `port` in its name,
> all the ports are set to `auto` (that's what laptop-mode-tools does).

Here we go.

> Right now I think I see three possibly unrelated issues:
> 
> Issue #1. BT trackpad not working properly when connected to the
> builtin bluetooth adapter.
> ----------
> 
> The adapter is attached to a USB1.1 hub:
> 
> ~~~~
> # lsusb -t
> ...
> /:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
>     |__ Port 2: Dev 2, If 0, Class=Wireless, Driver=btusb, 12M
>     |__ Port 2: Dev 2, If 1, Class=Wireless, Driver=btusb, 12M
>     |__ Port 2: Dev 2, If 2, Class=Vendor Specific Class, Driver=, 12M
>     |__ Port 2: Dev 2, If 3, Class=Application Specific Interface, Driver=, 12M
> ...
> 
> # cat usb3/power/control
> auto
> 
> # cat usb3/3-*/usb3-port*/power/control
> auto
> auto

Try setting this to on.

> # cat usb3/3-2/power/control
> on

Here "auto" should work. Please try.
[..]
> Issue #2. No hotplug with USB1.1:
> ----------
> 
> To see this I pick one physical port. When I plug a USB1.1 device it
> appears on bus 4 port 2; a USB2.0 device appears on bus 1 port 4.
> 
> ~~~~
> # cat usb4/power/control
> auto
> # cat usb4/4-*/usb4-port*/power/control
> auto
> auto

Please set this to "on"

> # cat usb1/power/control
> auto
> # cat usb1/1-*/usb1-port*/power/control

Please set this to "on"

[..]
> 
> Issue #3. No hot-plug-out for USB1.1.
> --------

> I think that the first two issues are fixed by keeping all the USB1.1
> hubs and the builtin BT always `on`, but I just wanted to know whether
> those are hardware or software bugs.

I suspect this is caused by outdated laptop-mode-tools.

Basically setting the port controls (as opposed to hub and device
controls) to "auto" tells the kernel that it may disable hotplugging
to save energy. Hotunplug for devices that need remote wakeup will
still work. Likewise if you disable autosuspend of the attached devices.

	Regards
		Oliver


