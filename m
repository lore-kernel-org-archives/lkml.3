Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810Ab3GPSd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:33:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab3GPSd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:33:28 -0400
Date: Tue, 16 Jul 2013 11:31:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: driver model, duplicate names question
Message-ID: <20130716183149.GA6164@kroah.com>
References: <51E57631.2030805@linux.intel.com>
 <20130716164459.GB17827@kroah.com>
 <51E59116.2060801@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E59116.2060801@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 11:29:42AM -0700, Srinivas Pandruvada wrote:
> Thanks for the quick response. Here I am creating virtual devices using 
> device_register.
> I have attached a simple test program, which will give error.
> 
> This is my intention:
> 
> $> cd /sys/class/test_class
> $> ls
> power_zone_cpu_package_0
> power_zone_cpu_package_1

Wait, you are mixing a class and a "real" bus up.  This will fail as
your devices all end up on the virtual "bus" with the same name, in the
same location on the bus (look in /sys/devices/virtual/ for where they
will end up at.

That will fail, and rightly so.

Try using this with the proper 'struct bus_type' and let me know if
creating a device there with the same name will also fail.

Oh crud, it will, because we can't create symlinks with the same bus
type in the /sys/bus/BUSTYPE/devices/ directory.

So, don't use the same name for a device on the same bus, that way
causes confusion :)

Let's get back to your original "problem", what again are you trying to
solve?  There should be a way to resolve this without having to deal
with duplicate names, perhaps you just want an attribute group with a
common name?

thanks,

greg k-h
