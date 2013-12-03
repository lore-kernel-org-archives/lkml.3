Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3LCO1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:27:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3LCO10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:27:26 -0500
Date: Tue, 3 Dec 2013 06:28:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH 5/6] GenWQE Sysfs interfaces
Message-ID: <20131203142828.GA3521@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
 <1383741943-14609-6-git-send-email-haver@linux.vnet.ibm.com>
 <20131127192204.GC28409@kroah.com>
 <1386075193.839.3.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386075193.839.3.camel@oc7383187364.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 01:53:13PM +0100, Frank Haverkamp wrote:
> Hi Greg,
> 
> thanks for taking your time to review our code once more.
> 
> Am Mittwoch, den 27.11.2013, 11:22 -0800 schrieb Greg KH:
> > On Wed, Nov 06, 2013 at 01:45:42PM +0100, Frank Haverkamp wrote:
> > > +/**
> > > + * genwqe_init_sysfs() - Setup sysfs entries of the card device
> > > + */
> > > +int genwqe_init_sysfs(struct genwqe_dev *cd)
> > > +{
> > > +	int rc;
> > > +
> > > +	rc = sysfs_create_group(&cd->dev->kobj, &genwqe_attribute_group);
> > > +	if (rc)
> > > +		return -ENXIO;
> > > +
> > > +	return 0;
> > > +}
> > 
> > Why isn't this group the "default" one for the device?  That way you
> > don't have to explicitly create/remove it, the driver core handles it
> > all automatically for you, and you don't race with userspace when it is
> > created/announced.
> 
> I found the ..._with_groups variant of device_create:
>         cd->dev = device_create_with_groups(cd->class_genwqe,
>                                             &cd->pci_dev->dev,
>                                             cd->devnum_genwqe, cd,
>                                             genwqe_attribute_groups,
>                                             GENWQE_DEVNAME "%u_card",
>                                             cd->card_idx);
> 
> This works nicely for me too. Is that what you had in mind?

Yes, that's what it was created for :)

