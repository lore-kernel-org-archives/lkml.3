Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3IFWAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 18:00:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:44591 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab3IFWAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 18:00:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,857,1371106800"; 
   d="scan'208";a="397891460"
Subject: Re: [PATCH RESEND v3 3/7] Intel MIC Host Driver, card OS state
 management.
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
In-Reply-To: <20130906190446.GA7965@kroah.com>
References: <cover.1378423596.git.sudeep.dutt@intel.com>
	 <669a3a3bbfff577c73d05fb568a810cbbc3d5333.1378423596.git.sudeep.dutt@intel.com>
	 <20130906050157.GF28806@kroah.com> <1378492863.107744.69.camel@localhost>
	 <20130906190446.GA7965@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Sep 2013 15:00:23 -0700
Message-ID: <1378504823.121061.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-06 at 12:04 -0700, Greg Kroah-Hartman wrote:
> On Fri, Sep 06, 2013 at 11:41:03AM -0700, Sudeep Dutt wrote:
> > On Thu, 2013-09-05 at 22:01 -0700, Greg Kroah-Hartman wrote:
> > > On Thu, Sep 05, 2013 at 04:41:55PM -0700, Sudeep Dutt wrote:
> > > > +What:		/sys/class/mic/mic(x)/firmware
> > > > +Date:		August 2013
> > > > +KernelVersion:	3.11
> > > > +Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
> > > > +Description:
> > > > +		When read, this sysfs entry provides the path name under
> > > > +		/lib/firmware/ where the firmware image to be booted on the
> > > > +		card can be found. The entry can be written to change the
> > > > +		firmware image location under /lib/firmware/.
> > > 
> > > I don't understand, is the path under the HOST device, or the Client
> > > device's disk?  Why do you need to change the path on the HOST?  What's
> > > wrong with the existing firmware path selection we have in the kernel?
> > > 
> > 
> > The path is on the host. The card does not have a physical persistent
> > disk device. Our customers like the flexibility of changing the card
> > firmware/ramdisk contents and file names for individual MIC cards. This
> > flexibility is not possible with a static set of firmware file names in
> > the kernel for all cards.
> > 
> > Once the firmware/ramdisk path under /lib/firmware/ is set up via sysfs,
> > card boot is initiated via the "state" sysfs entry. The host driver then
> > obtains the contents of the firmware and ramdisk via the standard
> > request_firmware(..) interface, copies the contents to card memory and
> > interrupts the card BIOS to initiate boot.
> 
> So this is really a "filename" that might contain some directories as
> well, right?  The fact you used "path" confused me, as that doesn't
> usually imply a filename.
> 

Yes, it is a filename that might contain some directories. We will fix
up the documentation here to read filename in future patches.

> And is the "firmware" just the initramfs image for the kernel to boot?
> 

The firmware is usually a Linux kernel. The ramdisk is usually an
initramfs image. We have separate sysfs entries for firmware and ramdisk
filenames.

Thanks,
Sudeep Dutt

> thanks,
> 
> greg k-h


