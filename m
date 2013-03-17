Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab3CQOBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:01:24 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:42065 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261Ab3CQOBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:01:21 -0400
MIME-Version: 1.0
In-Reply-To: <1363527503.16793.75.camel@ul30vt.home>
References: <20130316213512.2974.17303.stgit@amt.stowe> <20130316213519.2974.38954.stgit@amt.stowe>
 <20130316221159.GA3702@kroah.com> <1363477853.2423.25.camel@zim.stowe>
 <20130317010317.GB9641@kroah.com> <1363493482.16793.69.camel@ul30vt.home>
 <20130317053611.GC948@kroah.com> <1363527503.16793.75.camel@ul30vt.home>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 17 Mar 2013 15:00:59 +0100
Message-ID: <CAPXgP12vmx9j_jJW3HXb2deRapFKAofTVzEbdyS=Z1VUBswE_Q@mail.gmail.com>
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Myron Stowe <mstowe@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, linux-hotplug@vger.kernel.org,
        linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 2:38 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> I'm assuming that the device only breaks because udevadm is dumping the
> full I/O port register space of the device and that if an actual driver
> was interacting with it through this interface that it would work.  Who
> knows how many devices will have read side-effects by udevadm blindly
> dumping these files.  Thanks,

Sysfs is a too public interface to export things there which make
devices/driver choke on a simple read() of an attribute.

This is nothing specific to udevadm, any tool can do that. Udevadm
will never read any of the files during normal operation. The admin
explicitly asked udevadm with a specific command to dump all the stuff
the device offers.

The kernel driver needs to be fixed to allow that, in the worst case,
the attributes not exported at all. People should take more care what
they export in /sys, it's not a hidden and private ioctl what's
exported there, stuff is very visible and will be looked at.

Telling userspace not to use specific stuff in /sys I would not expect
to work as a strategy; there is too much weird stuff out there that
will always try to do that ...

Thanks,
Kay
