Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaHZR0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:26:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43118 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751435AbaHZR0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:26:30 -0400
Date: Tue, 26 Aug 2014 13:26:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Gavin Guo <gavin.guo@canonical.com>
cc: linux-usb@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>, YK <yk@canonical.com>
Subject: Re: About the reboot hang issue with EHCI driver on the Baytrail
 platform
In-Reply-To: <CA+eFSM0N_DQrfxiAjBdXy=cirONv03K+bRYCAcgAwtzZ=OxybQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1408261323510.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Gavin Guo wrote:

> >>  And IIRC, there is only one host controller within
> >> EHCI and XHCI can be enabled in the Baytrail platform. I'm also trying
> >> to find out the kernel parameters to disable the EHCI driver, but
> >> currently there is no available one.
> >
> > It's not a kernel parameter.  You can blacklist the ehci-pci and
> > ehci-hcd modules in /etc/modprobe.d/local.conf.
> >
> > Or you can turn off CONFIG_USB_EHCI_HCD in your .config and build a
> > kernel with no EHCI support at all.
> 
> Thanks for your response, I'm sorry that I didn't describe the
> question clearly. Because the EHCI support is built-in with Ubuntu
> kernel. I tried to find a way to disable that. Unfortunately, I only
> found "nousb" can disable it. But it will disable all the USB
> subsystem. Don't know if there is any chance to disable EHCI only.

I see.  No, there isn't any way to disable EHCI support at boot time if 
it is built into the kernel.  The best you can do is use the sysfs 
"unbind" attribute, and that may not always be good enough for what you 
want.

Still, why not use the BIOS setting to disable EHCI?

Alan Stern

