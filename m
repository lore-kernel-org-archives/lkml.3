Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3CPWKz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 18:10:55 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46469 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3CPWKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 18:10:52 -0400
Date: Sat, 16 Mar 2013 15:11:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: kay@vrfy.org, linux-hotplug@vger.kernel.org, alex.williamson@redhat.com,
        linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
Message-ID: <20130316221159.GA3702@kroah.com>
References: <20130316213512.2974.17303.stgit@amt.stowe>
 <20130316213519.2974.38954.stgit@amt.stowe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316213519.2974.38954.stgit@amt.stowe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 03:35:19PM -0600, Myron Stowe wrote:
> Sysfs includes entries to memory that backs a PCI device's BARs, both I/O
> Port space and MMIO.  This memory regions correspond to the device's
> internal status and control registers used to drive the device.
> 
> Accessing these registers from userspace such as "udevadm info
> --attribute-walk --path=/sys/devices/..." does can not be allowed as
> such accesses outside of the driver, even just reading, can yield
> catastrophic consequences.
> 
> Udevadm-info skips parsing a specific set of sysfs entries including
> 'resource'.  This patch extends the set to include the additional
> 'resource<N>' entries that correspond to a PCI device's BARs.

Nice, are you also going to patch bash to prevent a user from reading
these sysfs files as well?  :)

And pciutils?

You get my point here, right?  The root user just asked to read all of
the data for this device, so why wouldn't you allow it?  Just like
'lspci' does.  Or bash does.

If this hardware has a problem, then it needs to be fixed in the kernel,
not have random band-aids added to various userspace programs to paper
over the root problem here.  Please fix the kernel driver and all should
be fine.  No need to change udevadm.

greg k-h
