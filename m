Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3IFTEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:04:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3IFTEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:04:47 -0400
Date: Fri, 6 Sep 2013 12:04:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
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
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH RESEND v3 3/7] Intel MIC Host Driver, card OS state
 management.
Message-ID: <20130906190446.GA7965@kroah.com>
References: <cover.1378423596.git.sudeep.dutt@intel.com>
 <669a3a3bbfff577c73d05fb568a810cbbc3d5333.1378423596.git.sudeep.dutt@intel.com>
 <20130906050157.GF28806@kroah.com>
 <1378492863.107744.69.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378492863.107744.69.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 11:41:03AM -0700, Sudeep Dutt wrote:
> On Thu, 2013-09-05 at 22:01 -0700, Greg Kroah-Hartman wrote:
> > On Thu, Sep 05, 2013 at 04:41:55PM -0700, Sudeep Dutt wrote:
> > > +What:		/sys/class/mic/mic(x)/firmware
> > > +Date:		August 2013
> > > +KernelVersion:	3.11
> > > +Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
> > > +Description:
> > > +		When read, this sysfs entry provides the path name under
> > > +		/lib/firmware/ where the firmware image to be booted on the
> > > +		card can be found. The entry can be written to change the
> > > +		firmware image location under /lib/firmware/.
> > 
> > I don't understand, is the path under the HOST device, or the Client
> > device's disk?  Why do you need to change the path on the HOST?  What's
> > wrong with the existing firmware path selection we have in the kernel?
> > 
> 
> The path is on the host. The card does not have a physical persistent
> disk device. Our customers like the flexibility of changing the card
> firmware/ramdisk contents and file names for individual MIC cards. This
> flexibility is not possible with a static set of firmware file names in
> the kernel for all cards.
> 
> Once the firmware/ramdisk path under /lib/firmware/ is set up via sysfs,
> card boot is initiated via the "state" sysfs entry. The host driver then
> obtains the contents of the firmware and ramdisk via the standard
> request_firmware(..) interface, copies the contents to card memory and
> interrupts the card BIOS to initiate boot.

So this is really a "filename" that might contain some directories as
well, right?  The fact you used "path" confused me, as that doesn't
usually imply a filename.

And is the "firmware" just the initramfs image for the kernel to boot?

thanks,

greg k-h
