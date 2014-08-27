Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935619AbaH0Uvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:51:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaH0Uva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:51:30 -0400
Date: Wed, 27 Aug 2014 13:51:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci/pci-sysfs: Set pci interface in uppercase
Message-ID: <20140827205129.GA25227@kroah.com>
References: <1409144277-23379-1-git-send-email-ricardo.ribalda@gmail.com>
 <20140827202301.GA13800@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827202301.GA13800@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 01:23:01PM -0700, Greg KH wrote:
> On Wed, Aug 27, 2014 at 02:57:57PM +0200, Ricardo Ribalda Delgado wrote:
> > There is a missmatch between the way file2alias generates the modalias
> > and the way the pci driver generates it.
> > 
> > Some implementations of modprobe will fail to load the driver for a pci
> > device automatically when the pci interface is defined on the driver. As
> > one will be in uppercase and the other in lowercase.
> > 
> > Fortunatelly not many drivers define this.
> > 
> > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > ---
> >  drivers/pci/pci-sysfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> > index 9ff0a90..76ef791 100644
> > --- a/drivers/pci/pci-sysfs.c
> > +++ b/drivers/pci/pci-sysfs.c
> > @@ -177,7 +177,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
> >  {
> >  	struct pci_dev *pci_dev = to_pci_dev(dev);
> >  
> > -	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x\n",
> > +	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02X\n",
> >  		       pci_dev->vendor, pci_dev->device,
> >  		       pci_dev->subsystem_vendor, pci_dev->subsystem_device,
> >  		       (u8)(pci_dev->class >> 16), (u8)(pci_dev->class >> 8),
> 
> As said in the other thread about this issue, no, this code has been
> here for over 9 years just fine.  Please fix your userspace code that is
> trying to compare hex values as a string and not a numeric value, that
> is the stuff that is wrong, not the kernel.

Oh wait, I see what you are worried about now, the mis-match for just
the upper bits of the class value.

Yeah, that's a bug, sorry about that, a 9+ year old one, nice catch :)

Bjorn, feel free to apply this, sorry for the earlier objection.  Also
please mark it for stable tree inclusion so this gets backported
properly.

thanks,

greg k-h
