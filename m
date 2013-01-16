Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab3APIZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:25:55 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:44469 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3APIZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:25:54 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Woody Suwalski <terraluna977@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andreas Mohr <andi@lisas.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.8-rc1 - another regression on USB :-(
Date: Wed, 16 Jan 2013 09:25:55 +0100
Message-ID: <2016859.MDetYcSki9@linux-5eaq.site>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50F62BEC.4060602@gmail.com>
References: <Pine.LNX.4.44L0.1301121237570.32458-100000@netrider.rowland.org> <50F62BEC.4060602@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2013 23:26:20 Woody Suwalski wrote:

> The modules are insmoded in a fixed order:
> usb-common, usbcore, xhci-hcd, ehci-hcd, uhci-hcd, ohci-hcd, usbhid, 
> usb_storage,...
> 
> If all USB is built as modules - I get read errors from USB drives when 
> accessing squash image, boot fails.
> If usb-common and usbcore are built in, system seems to crawl with a 
> very slow USB, but boots. That could be caused by timing between hcd 
> modules.

Have you checked which bus the storage device is on?
If it is attached to a companion controller that would explain the speed
issue.

> If usb-common, usbcore and ehci-hcd are built-in, all works OK like 
> "before 3.8".
> I was testing on machines  without xhci or ohci hardware, so these 
> drivers probably are not playing any role.
> I have retried initramfs with a 1s sleep between insmods to verify if it 
> is timing - still the same read errors - so the main issue is _not_ timing.
> The read errors problem is 100% reproducible for me, the blocks where 
> read fails are not fixed - every (failed) boot errors start appearing in 
> a bit different location.

Do you get read errors on the SCSI level only or also errors on the USB level?

	Regards
		Oliver

