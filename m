Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab3CQOUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:20:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340Ab3CQOUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:20:33 -0400
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
From: Myron Stowe <mstowe@redhat.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Myron Stowe <myron.stowe@redhat.com>, linux-hotplug@vger.kernel.org,
        linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAPXgP12vmx9j_jJW3HXb2deRapFKAofTVzEbdyS=Z1VUBswE_Q@mail.gmail.com>
References: <20130316213512.2974.17303.stgit@amt.stowe>
	 <20130316213519.2974.38954.stgit@amt.stowe>
	 <20130316221159.GA3702@kroah.com> <1363477853.2423.25.camel@zim.stowe>
	 <20130317010317.GB9641@kroah.com> <1363493482.16793.69.camel@ul30vt.home>
	 <20130317053611.GC948@kroah.com> <1363527503.16793.75.camel@ul30vt.home>
	 <CAPXgP12vmx9j_jJW3HXb2deRapFKAofTVzEbdyS=Z1VUBswE_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Mar 2013 08:20:28 -0600
Message-ID: <1363530028.2423.43.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-17 at 15:00 +0100, Kay Sievers wrote:
> On Sun, Mar 17, 2013 at 2:38 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > I'm assuming that the device only breaks because udevadm is dumping the
> > full I/O port register space of the device and that if an actual driver
> > was interacting with it through this interface that it would work.  Who
> > knows how many devices will have read side-effects by udevadm blindly
> > dumping these files.  Thanks,
> 
> Sysfs is a too public interface to export things there which make
> devices/driver choke on a simple read() of an attribute.
> 
> This is nothing specific to udevadm, any tool can do that. Udevadm
> will never read any of the files during normal operation. The admin
> explicitly asked udevadm with a specific command to dump all the stuff
> the device offers.
> 
> The kernel driver needs to be fixed to allow that, in the worst case,
> the attributes not exported at all. People should take more care what
> they export in /sys, it's not a hidden and private ioctl what's
> exported there, stuff is very visible and will be looked at.
> 
> Telling userspace not to use specific stuff in /sys I would not expect
> to work as a strategy; there is too much weird stuff out there that
> will always try to do that ...

Kay - could you comment on Foot Note 3 in
https://lkml.org/lkml/2013/3/16/168

With respect to 'udev', you are working on the assumption that all files
in sysfs must be readable with no consequences which may be implied by
the Documentation's sysfs.txt file's mentioning ASCII.  If we are to
interpret that as strictly as you seem to want to then why is there
sysfs support for creating binary files?

Myron
> 
> Thanks,
> Kay


