Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab3DDBGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 21:06:09 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36104 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab3DDBGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 21:06:07 -0400
Date: Wed, 3 Apr 2013 18:06:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: GPS driver for Linux - kernel or user-space driver?
Message-ID: <20130404010604.GC19599@kroah.com>
References: <515CCEB3.4020309@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515CCEB3.4020309@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 05:52:03PM -0700, Tim Bird wrote:
> I've been approached by a developer at Sony who wants to publish an
> open source driver for a Sony GPS receiver module.

What does the device look like?  USB device?  UART?  Something else?

> I've looked in the kernel source, and only see one standalone GPS
> driver, for Garmin.  It appears that most GPS support in Linux is done
> via user-space drivers.  Many GPS hardware modules appear to be
> accessed via a serial line, or USB/serial port.  The Sony
> module is pretty much the same, accepting commands and delivering
> data via a uart from the chip.
> 
> I planning to recommend writing a user-space driver (based on
> gpsd and/or the Android GPS HAL specification).  But I'm worried
> I'm missing something.  Is this the correct approach, or is there
> an established kernel API for GPS modules - such that I should
> recommend that this developer writes a kernel module instead
> of, or in addition to, the user-space support for the hardware?

If it's just a uart-like device, just write a serial driver and drive it
from gpsd.  That way seems to be the simplest and then the kernel just
becomes a dumb-pipe, which is fine.

thanks,

greg k-h
