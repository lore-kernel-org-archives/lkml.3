Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3JWPVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 11:21:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3JWPVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 11:21:19 -0400
Date: Wed, 23 Oct 2013 16:22:50 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: haver@linux.vnet.ibm.com, Frank Haverkamp <haver@vnet.ibm.com>,
        linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver
Message-ID: <20131023152250.GA5224@kroah.com>
References: <1374740897-20304-1-git-send-email-haver@vnet.ibm.com>
 <1374740897-20304-2-git-send-email-haver@vnet.ibm.com>
 <51F12668.8000400@suse.cz>
 <1382534154.2791.8.camel@oc7383187364.ibm.com>
 <20131023134059.GB21936@sepie.suse.cz>
 <1382537663.4940.7.camel@oc7383187364.ibm.com>
 <5267E601.208@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5267E601.208@suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 05:06:41PM +0200, Michal Marek wrote:
> On 23.10.2013 16:14, Frank Haverkamp wrote:
> > of course you are right. Let me try again.
> > 
> > I hope this looks better now:
> > + dev_info(&pci_dev->dev, "GenWQE driver version: %s %s%u\n",
> > + DRV_VERS_STRING, GENWQE_DEVNAME, cd->card_idx);
> > ...

Also, _no_ driver should ever be doing this type of "hey, look at me,
I'm now loaded!" type syslog spam anymore.  It's pointless, and should
be abolished where ever possible.  That's one reason we have moved to
the driver init type functions that make this impossible to do, and if
possible, I recommend doing that here as well.

thanks,

greg k-h
