Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaJ0Txl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:53:41 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30631 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaJ0Txk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:53:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+XjhmcRQwO5ryHVkYaHAaa
Date: Mon, 27 Oct 2014 12:52:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Felipe Balbi <balbi@ti.com>, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141027195209.GP2560@atomide.com>
References: <20141019090107.GA19132@amd>
 <201410262222.39892@pali>
 <20141026215548.GA9004@amd>
 <201410262323.17891@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201410262323.17891@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [141026 15:24]:
> On Sunday 26 October 2014 22:55:48 Pavel Machek wrote:
> > > > I have root prepared on /dev/mmcblk0p6. I tried 3.17 with
> > > > rx51_defconfig, but no, it refuses to mount it.
> > > > 
> > > > VFS: Cannot open root device "mmcblk0p6" or ....: error
> > > > -19.
> > > > 
> > > > And then it proceeds to list mmcblk0p6 as one of available
> > > > options
> > > > 
> > > > :-(.
> > > > 
> > > > Ideas welcome.
> > > 
> > > Try to add rootdelay=30 or rootwait to kernel cmdline.
> > 
> > I had rootdelay=3. Will try rootwait... no change. This is
> > v3.17 with rx51_defconfig. CONFIG_MACH_NOKIA_RX51=y => device
> > tree will not be used AFAICT.
> > 
> > Now I'm back at 3.14 without device tree; same setup works
> > there. I tried disabling RX51 support in 3.14 (to make it
> > boot using device tree) but that did not work.
> > 								Pavel
> 
> I remember that there was some problem with initializing mmc 
> device. Sometimes something failed and reading from eMMC was not 
> possible. Try to boot kernel from uboot. Maybe it can help.

Would be nice to have both the USB and the MMC issues sorted
out in the mainline kernel naturally and get rid of any bootloader
dependencies.

I think the USB issue because usb_gadget_probe_driver() bails
out with -ENODEV before the USB controller is found. Felipe, got
any ideas how to fix this to work with -EPROBE_DEFER? Should this
get called only from the USB controller probe?

Regards,

Tony
