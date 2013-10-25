Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3JYOAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:00:55 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:40704 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab3JYOAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:00:53 -0400
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v3)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        jsvogt@de.ibm.com, MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com,
        michael@ibmra.de, Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <20131025104212.GA22369@kroah.com>
References: <20131024100942.GA13614@kroah.com>
	 <1382695784-10127-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131025104212.GA22369@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 25 Oct 2013 16:00:44 +0200
Message-ID: <1382709644.8698.31.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102514-4966-0000-0000-0000074AF56E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

thanks for having a first look at the code.

Am Freitag, den 25.10.2013, 11:42 +0100 schrieb Greg KH:
> On Fri, Oct 25, 2013 at 12:09:44PM +0200, Frank Haverkamp wrote:
> > From: Frank Haverkamp <haver@vnet.ibm.com>
> > 
> > The GenWQE card itself provides access to a generic work queue into
> > which the work can be put, which should be executed, e.g. compression
> > or decompression request, or whatever the card was configured to do.
> > 
...
> > 
> > Signed-off-by: Frank Haverkamp <haver@vnet.ibm.com>
> > Co-authors: Joerg-Stephan Vogt <jsvogt@de.ibm.com>,
> >             Michael Jung <MIJUNG@de.ibm.com>,
> >             Michael Ruettger <michael@ibmra.de>
> 
> Please run sparse on the code and fix up the issues that it finds (a
> short glance seems that there will be some issues, I didn't run it
> myself.)

Yes, sparse was complaining. Fortunately it was mostly about me not
putting __user at the right spots as far as I could see. I tried to fix
that in my local copy.

> And why are you doing debug stuff through the ioctl interface?  Please
> move that to debugfs if you really want/need that information, it does
> not belong in an ioctl.

I will look into that. We need that information per card when it fails.

> Your huge numbers of module parameters are also worrying.  I think
> almost all of them should be sysfs files on a per device/card as you can
> not handle different options for different cards with module parameters.

You are right. Some of them were useful for debugging, but do not really
make sense for regular users e.g. distros. I removed some already, but
for some others I am not yet sure yet if I want them to go away.

> Please remove all of them, as no distro/user will _ever_ know what to do
> with a module option, it's not fair to push those types of decisions to
> users where you can't make up your mind as a kernel developer.

True. Normally we did not change those. But we sometimes used them when
trying out the card in different environments e.g. different processor
architecture or special test-cases which required higher timeout values.

> One final legal question:
> 
> > --- /dev/null
> > +++ b/drivers/misc/genwqe/card_base.c
> > @@ -0,0 +1,1305 @@
> > +/**
> > + * IBM Accelerator Family 'GenWQE'
> > + *
> > + * (C) Copyright IBM Corp. 2013
> > + *
> > + * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
> > + * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
> > + * Author: Michael Jung <mijung@de.ibm.com>
> > + * Author: Michael Ruettger <michael@ibmra.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2, or (at your option)
> > + * any later version.
> 
> Do you _really_ mean "any later version"?  I have to ask, sorry.

I think we can change that to something like:

 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License (version 2 only)
 * as published by the Free Software Foundation.

> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
> > + * GNU General Public License for more details.
> 
> What's with the odd spacing of that last sentence?

Tab/space issue. I fixed that.

> Thanks for not putting the FSF's office address in this part of the
> files, that's much appreciated.

I think Martin recommended that to me.

> thanks,
> 
> greg k-h
> 

Have a nice weekend.

Frank

