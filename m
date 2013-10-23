Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3JWSPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 14:15:35 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47140 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3JWSPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 14:15:33 -0400
Date: Wed, 23 Oct 2013 11:15:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Michal Marek <mmarek@suse.cz>, haver@linux.vnet.ibm.com,
        Frank Haverkamp <haver@vnet.ibm.com>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        utz.bacher@de.ibm.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michae@jasper.es
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver
Message-ID: <20131023181525.GB23728@roeck-us.net>
References: <1374740897-20304-1-git-send-email-haver@vnet.ibm.com>
 <1374740897-20304-2-git-send-email-haver@vnet.ibm.com>
 <51F12668.8000400@suse.cz>
 <1382534154.2791.8.camel@oc7383187364.ibm.com>
 <20131023134059.GB21936@sepie.suse.cz>
 <20131023152250.GA5224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131023152250.GA5224@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 04:22:50PM +0100, Greg KH wrote:
> On Wed, Oct 23, 2013 at 05:06:41PM +0200, Michal Marek wrote:
> > On 23.10.2013 16:14, Frank Haverkamp wrote:
> > > of course you are right. Let me try again.
> > > 
> > > I hope this looks better now:
> > > + dev_info(&pci_dev->dev, "GenWQE driver version: %s %s%u\n",
> > > + DRV_VERS_STRING, GENWQE_DEVNAME, cd->card_idx);
> > > ...
> 
> Also, _no_ driver should ever be doing this type of "hey, look at me,
> I'm now loaded!" type syslog spam anymore.  It's pointless, and should
> be abolished where ever possible.  That's one reason we have moved to
> the driver init type functions that make this impossible to do, and if
> possible, I recommend doing that here as well.
> 
I agree. Do we have that as a general policy written down somewhere ?
That would help in reviews with authors insisting that they absolutely
want such messages. 

Thanks,
Guenter
