Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab3JVFmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 01:42:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3JVFmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 01:42:43 -0400
Date: Tue, 22 Oct 2013 06:44:06 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bin Gao <bin.gao@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] drivers/misc: add rawio framework and drivers
Message-ID: <20131022054406.GA14163@kroah.com>
References: <5265C0C5.70905@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5265C0C5.70905@linux.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 05:03:17PM -0700, Bin Gao wrote:
> To read/write registers from a device is very important on embedded system,
> especially SoC systems. Physically there could be different types of devices
> based on bus tyes, e.g. PCI devices, I2C (slave)devices, I/O devices(memory
> mapped), inter-processor devices, etc. Typically there are userland
> tools from
> PC Linux to access device registers, but on some embedded system initrd and
> rootfs come with a minimal busybox and most useful userland tools are not
> available. To add these tools back to rootfs is not convenient either.
> What's more, on some systems with runtime pm enabled, reading/writing
> registers
> from a device which is in low power state will cause problems. For these
> reasons, to have some tools/interfaces directly from kernel space via debug
> fs seems to be easy, cheap and convenient.

So, just because userspace is "hard" you want to add stuff to the kernel
instead.

Sorry, but for over the past decade, we have been doing just the
opposite, if things can be done in userspace, then they should be done
there.  So for us to go in the opposite direction, like these patches
show, would be a major change.

> These patchsets are designed to  achieve above goals to ease
> device driver and kernel debugging on embedded systems.
> 
> Rawio provides a framework to read/write registers from a bus, including
> pci, i2c, I/O device(memory mapped), etc. based on debug fs.
> Rawio bus drivers implement the read/write operation on a specific bus
> on top of the rawio framework driver.
> Currently only three bus drivers are available: pci, iomem and i2c.

You can already do this today for PCI with the UIO framework, right?
Why duplicate that functionality here with another userapce API that we
will then have to maintain for the next 40+ years?

> But it's extremely easy to add more drivers on top of the framework
> if needed.
> 
>  drivers/misc/Kconfig             |   1 +
>  drivers/misc/Makefile            |   1 +
>  drivers/misc/rawio/Kconfig       |  59 +++++
>  drivers/misc/rawio/Makefile      |   4 +
>  drivers/misc/rawio/rawio.c       | 514
> +++++++++++++++++++++++++++++++++++++++

All of your patches are line-wrapped and totally fail to apply, so even
if we wanted to take this type of changes, I couldn't :(

Have you run these proposed changes by any of the Intel kernel
developers?  What did they say to them?

If not, why haven't you, isn't that a resource you should be using for
things like this?

greg k-h
