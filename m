Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbaIOT4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:56:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaIOT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:56:18 -0400
Date: Mon, 15 Sep 2014 12:56:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Darren Hart <dvhart@infradead.org>
Cc: Azael Avalos <coproscefalo@gmail.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 3/5] toshiba_acpi: Fix accelerometer direction
 reporting
Message-ID: <20140915195617.GA3652@kroah.com>
References: <1410569437-3066-1-git-send-email-coproscefalo@gmail.com>
 <1410569437-3066-2-git-send-email-coproscefalo@gmail.com>
 <20140915192923.GA61529@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915192923.GA61529@vmdeb7>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 12:29:27PM -0700, Darren Hart wrote:
> On Fri, Sep 12, 2014 at 06:50:37PM -0600, Azael Avalos wrote:
> > The position file on sysfs was reporting absolute values
> > for its axes.
> > 
> > This patch fixes the direction reporting (either negative
> > or positive), as well as added a mutex lock to it.
> > 
> 
> Hi All,
> 
> I've added Greg KH, Rafael, and H. Peter Anvin to get some clarity on a topic
> which is coming up repeatedly in the platform-drivers-x86 subsystem.
> Specifically, whether or not the driver-specific sysfs attributes should be
> considered a "stable userspace interface".
> 
> The sysfs documentation [1] specfifically calls out the following types of
> device properties:
> 
> o devpath
> o kernel name
> o subsystem
> o driver
> o attributes (the topic of this email)
> 
> In the case of this patch, Azael proposes changing the x,y,z attributes from the
> absolute values read from the device to relative signed values.
> 
> In my opinion, this changes a userspace interface that exists prior to this
> development cycle. As such, the attributes must remain as they are and new
> attributes should be added if a new interface is wanted/needed. New x_rel,
> y_rel, z_rel attributes could be added for this purpose.

Yes, never change existing files to start showing different types of
values, that's not ok.

But you can remove an existing file and replace it with something with a
different name, _IF_ the userspace tool that was using it can also be
changed.  But don't go creating new interfaces when an existing one is
already present, as shown by:

> I have also suggested this device (2 actually) would be better supported as an
> IIO accelerometer device, but even that would change the sysfs interface by
> removing these altogether and using the IIO standardized path and accelerometer
> interface.

That's a better goal overall, then the "odd" sysfs files are now gone,
to be replaced with the standard interface which all tools should
already be using.

hope this helps,

greg k-h
