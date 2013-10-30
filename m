Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3J3NZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:25:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3J3NZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:25:49 -0400
Date: Wed, 30 Oct 2013 06:27:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next 2/8] mei: hbm: validate client index is not
 exceeding allocated array size
Message-ID: <20131030132748.GD30447@kroah.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
 <1382382343-12066-3-git-send-email-tomas.winkler@intel.com>
 <20131029231945.GB30410@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AEFB95D@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AEFB95D@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 07:31:06AM +0000, Winkler, Tomas wrote:
> 
> 
> > > ---
> > >  drivers/misc/mei/hbm.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
> > > index 9b3a0fb..0f5e8ca 100644
> > > --- a/drivers/misc/mei/hbm.c
> > > +++ b/drivers/misc/mei/hbm.c
> > > @@ -228,8 +228,6 @@ static int mei_hbm_prop_req(struct mei_device *dev)
> > >  	unsigned long client_num;
> > >
> > >
> > > -	client_num = dev->me_client_presentation_num;
> > > -
> > >  	next_client_index = find_next_bit(dev->me_clients_map,
> > MEI_CLIENTS_MAX,
> > >  					  dev->me_client_index);
> > >
> > > @@ -241,6 +239,10 @@ static int mei_hbm_prop_req(struct mei_device *dev)
> > >  		return 0;
> > >  	}
> > >
> > > +	client_num = dev->me_client_presentation_num;
> > > +	if (WARN_ON(dev->me_clients_num <= client_num))
> > > +		return -EIO;
> > 
> > How can this happen?  Why is spitting out a huge warning in the syslog
> > going to help anything?  If a user can do this, then great, now you can
> > DoS your syslog :(
> > 
> > If a user can't do this, then why tell them, it's your driver's bug that
> > you should just fix.
> 
> This somehow should guard buffer overflow allocated of size dev->me_clients_num
> In theory this can happen only if something go wrong in hardware
> initialization or there is some other security hole that can change
> client_num.

What _kind_ of "security hole" could ever change that number?  Where
does it come from?  Who can modify it?  If you don't know that now then
we have worse problems...

greg k-h
