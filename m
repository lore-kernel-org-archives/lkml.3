Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3LSCkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:40:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab3LSCkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:40:25 -0500
Date: Wed, 18 Dec 2013 17:07:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kim Phillips <kim.phillips@linaro.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, scottwood@freescale.com,
        R65777@freescale.com, B07421@freescale.com, B08248@freescale.com,
        christoffer.dall@linaro.org, alex.williamson@redhat.com,
        a.motakis@virtualopensystems.com, agraf@suse.de, B16395@freescale.com
Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
Message-ID: <20131219010729.GC23055@kroah.com>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 12:34:46PM +0000, Kim Phillips wrote:
> VFIO supports pass-through of devices to user space - for sake
> of illustration, say a PCI e1000 device:
> 
> - the e1000 is first unbound from the PCI e1000 driver via sysfs
> - the vfio-pci driver is told via new_id that it now handles e1000 devices
> - the e1000 is explicitly bound to vfio-pci through sysfs
> 
> However, now we have two drivers in the system that both handle e1000
> devices.  A hotplug event could then occur and it is ambiguous as to which
> driver will claim the device.  The desired semantics is that vfio-pci is
> only bound to devices by explicit request in sysfs.  This patch makes this
> possible by introducing a sysfs_bind_only flag in struct device_driver.

Why deal with this at all and not just deal with the "bind" sysfs file
instead?  That way no driver core logic needs to be changed at all, and
your userspace tools know _exactly_ which device is being bound to the
new device.

Don't mess with the "new_id" file for stuff like this, as you point out,
it's "tricky"...

thanks,

greg k-h
