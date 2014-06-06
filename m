Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaFFMHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:07:40 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:43786 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaFFMHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:07:39 -0400
Subject: Re: [PATCH 4/4] GenWQE: Increase driver version number
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, haver@linux.vnet.ibm.com
In-Reply-To: <20140605160010.GF23993@kroah.com>
References: <1401890273-13067-1-git-send-email-klebers@linux.vnet.ibm.com>
	 <1401890273-13067-5-git-send-email-klebers@linux.vnet.ibm.com>
	 <20140604155454.GA2866@kroah.com>
	 <1401960184.11932.10.camel@oc7383187364.ibm.com>
	 <20140605160010.GF23993@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 06 Jun 2014 14:07:33 +0200
Message-ID: <1402056453.31366.34.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060612-1948-0000-0000-00000018CBAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Donnerstag, den 05.06.2014, 09:00 -0700 schrieb Greg KH:
> On Thu, Jun 05, 2014 at 11:23:04AM +0200, Frank Haverkamp wrote:
> > Hi Greg,
> > 
> > Am Mittwoch, den 04.06.2014, 08:54 -0700 schrieb Greg KH:
> > > On Wed, Jun 04, 2014 at 10:57:53AM -0300, Kleber Sacilotto de Souza wrote:
> > > > Increase genwqe driver version number.
> > > > 
> > > > Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
> > > > ---
> > > >  drivers/misc/genwqe/genwqe_driver.h |    2 +-
> > > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/drivers/misc/genwqe/genwqe_driver.h b/drivers/misc/genwqe/genwqe_driver.h
> > > > index cd52631..a506e9a 100644
> > > > --- a/drivers/misc/genwqe/genwqe_driver.h
> > > > +++ b/drivers/misc/genwqe/genwqe_driver.h
> > > > @@ -36,7 +36,7 @@
> > > >  #include <asm/byteorder.h>
> > > >  #include <linux/genwqe/genwqe_card.h>
> > > >  
> > > > -#define DRV_VERS_STRING		"2.0.15"
> > > > +#define DRV_VERS_STRING		"2.0.21"
> > > 
> > > Why is this even needed?  Can't you go off of the kernel version number
> > > now?  Who needs / wants this number?
> > 
> > I am aware that if just considering the mainline kernels, we could use
> > the kernel version itself for the purpose of identifying which code we
> > are running.
> 
> Which is what you are patching here :)
> 
> > But in our lab we are running multiple back-ported versions of this
> > driver on different Linux distributions using different kernel versions.
> 
> Then deal with that in the backported code, the upstream kernel doesn't
> care about this.
> 
> > Our user-space software needs to know if the driver has or has not
> > bug-fixes or features. For this purpose, we are using this extra number.
> 
> Why would you rely on a version number for this, shouldn't you be able
> to tell with your api what features are present?

For version "2.0.15" there is no automatic recovery for certain
problems, for "2.0.21" there is.

I personally use the driver versions sysfs entry if a user complains
that something e.g. the recovery is not working right. First thing I am
asking for is the version of the code/driver  as part of the debug data.
If that is not matching my expectations, I will tell the user to update
the code.

In the current example new applications could more gracefully handle
failing recovery scenarios by knowing that the old version of the code
cannot properly handle certain problems. And it could this without
knowing if it is using a driver which is in the mainline tree or if it
is a back-ported version.

Therefore I find it much more convenient for us to handle such things
and I would kindly ask you to accept patch 4/4.

> thanks,
> 
> greg k-h

Thanks

Frank

