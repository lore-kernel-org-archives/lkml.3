Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaFACbK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 22:31:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaFACbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 22:31:08 -0400
Date: Sat, 31 May 2014 19:31:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Philipp Hachtmann <hachti@hachti.de>
Cc: jhovold@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb/ftdi_sio: Add support for setting CBUS pins on
 FT232H
Message-ID: <20140601023106.GA4961@kroah.com>
References: <1401579066-8298-1-git-send-email-hachti@hachti.de>
 <1401579066-8298-3-git-send-email-hachti@hachti.de>
 <20140601000059.27360.qmail@stuge.se>
 <538A7063.8010205@hachti.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538A7063.8010205@hachti.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 02:14:27AM +0200, Philipp Hachtmann wrote:
> On 01.06.2014 02:00, Peter Stuge wrote:
> >Philipp Hachtmann wrote:
> >>This patch adds a sysfs attribute "cbus" which allows to set the
> >>four CBUS pins on the FT232H.
> >
> >I think this should be implemented with the gpio subsystem instead.
> The GPIO subsystem seems to be made for GPIO pins connected directly to the
> computer. The Beaglebone with its AM335x SoC seems to be a good example of
> a computer with many GPIOs in the sense of the GPIO subsystem.
> And the GPIO pins have fixed unique numbers. No, I don't think that the GPIO
> subsystem has anything to do with the additional pins on some USB device.
> Please correct me if I'm completely wrong.

As they are GPIO pins on this device, it should be the subsystem that
controls it.  That way, userspace programs that are used to talk to a
GPIO device will "just work", and not have to be customized just for
this specific device and sysfs file.

So please use the GPIO subsystem instead of creating your own interface.

thanks,

greg k-h
