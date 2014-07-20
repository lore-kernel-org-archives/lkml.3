Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaGTPZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 11:25:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaGTPZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 11:25:36 -0400
Date: Sun, 20 Jul 2014 08:25:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: Re: [char-misc-next 4/5] mei: nfc: clean nfc internal struct on host
 exit
Message-ID: <20140720152512.GA31382@kroah.com>
References: <1405583618-8229-1-git-send-email-tomas.winkler@intel.com>
 <1405583618-8229-5-git-send-email-tomas.winkler@intel.com>
 <20140718013758.GA31846@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1C379CCB@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1C379CCB@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 06:30:16AM +0000, Winkler, Tomas wrote:
> > > @@ -553,6 +553,7 @@ void mei_nfc_host_exit(struct mei_device *dev)
> > >  {
> > >  	struct mei_nfc_dev *ndev = &nfc_dev;
> > >  	cancel_work_sync(&ndev->init_work);
> > > +	memset(ndev, 0, sizeof(struct mei_nfc_dev));
> > 
> > This implies that something is using a "static" device structure, which
> > isn't allowed by the driver core.  So please fix the root cause here,
> > don't paper over the bug.
> >
> You are partially correct as this is not the 'struct device' it just a nfc singleton in any case it is not really nice
> and  we have the fix in queue but it is rather extensive rework and  I guess it won't be suitable for stable
> so hence this one liner fix.

It shouldn't be a huge rework to make a static variable dynamic, right?
Please do it correctly.

thanks,

greg k-h
