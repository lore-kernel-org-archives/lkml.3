Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3LCMxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:53:23 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:44638 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3LCMxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:53:22 -0500
Subject: Re: [PATCH 5/6] GenWQE Sysfs interfaces
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <20131127192204.GC28409@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383741943-14609-6-git-send-email-haver@linux.vnet.ibm.com>
	 <20131127192204.GC28409@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 03 Dec 2013 13:53:13 +0100
Message-ID: <1386075193.839.3.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120312-3548-0000-0000-0000075963E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

thanks for taking your time to review our code once more.

Am Mittwoch, den 27.11.2013, 11:22 -0800 schrieb Greg KH:
> On Wed, Nov 06, 2013 at 01:45:42PM +0100, Frank Haverkamp wrote:
> > +/**
> > + * genwqe_init_sysfs() - Setup sysfs entries of the card device
> > + */
> > +int genwqe_init_sysfs(struct genwqe_dev *cd)
> > +{
> > +	int rc;
> > +
> > +	rc = sysfs_create_group(&cd->dev->kobj, &genwqe_attribute_group);
> > +	if (rc)
> > +		return -ENXIO;
> > +
> > +	return 0;
> > +}
> 
> Why isn't this group the "default" one for the device?  That way you
> don't have to explicitly create/remove it, the driver core handles it
> all automatically for you, and you don't race with userspace when it is
> created/announced.

I found the ..._with_groups variant of device_create:
        cd->dev = device_create_with_groups(cd->class_genwqe,
                                            &cd->pci_dev->dev,
                                            cd->devnum_genwqe, cd,
                                            genwqe_attribute_groups,
                                            GENWQE_DEVNAME "%u_card",
                                            cd->card_idx);

This works nicely for me too. Is that what you had in mind?
It saves two functions and if it gets rid of the race, nice.

> thanks,
> 
> greg k-h
> 
Regards

Frank


