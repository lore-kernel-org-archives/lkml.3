Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3KEMsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:48:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab3KEMsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:48:32 -0500
Date: Tue, 5 Nov 2013 04:50:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
Message-ID: <20131105125045.GA18093@kroah.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
 <20131030174403.GF20147@kroah.com>
 <1383583287.15642.29.camel@oc7383187364.ibm.com>
 <20131104221524.GD14141@kroah.com>
 <1383635784.11383.2.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383635784.11383.2.camel@oc7383187364.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 08:16:24AM +0100, Frank Haverkamp wrote:
> Hi Greg,
> 
> Am Montag, den 04.11.2013, 14:15 -0800 schrieb Greg KH:
> > > I am using sysfs_create_group() now, but do I understand you
> > correctly
> > > that setting the const struct attribute_group **groups; in my device
> > > (where in my struct pci_device.dev?) is an even better way to
> > establish
> > > my sysfs attributes? Is there a function which I could call rather
> > than
> > > trying to find the right pointer?
> > 
> > Ugh, this is still a problem, I'm trying to work through how to have
> > individual drivers implement groups and sysfs files in a non-racy way.
> > The issue is your device was announced to userspace _before_ it was
> > bound to the driver, so there's no way to get the sysfs files to apply
> > before then.
> > 
> > You should just have the attributes on the sysfs device you create
> > yourself, not your pci device, as that's where they make more sense,
> > and
> > there you should be able to use the attribute group easily, right?
> > 
> 
> The current version works well for me and I did not get any complaints
> about the possible race-condition you mentioned so far. So I am happy.

Just because you can't see the race happening, doesn't mean it isn't
there and will not show up for someone else.

A trivial way to see this is write a program that uses libudev that gets
notified when your device shows up and then read the attribute files.
Those files will not be present when your program is notified so the
read will usually fail.

greg k-h
