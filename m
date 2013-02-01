Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3BAPLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 10:11:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35221 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754053Ab3BAPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 10:11:44 -0500
Date: Fri, 1 Feb 2013 10:11:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aaron Lu <aaron.lu@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v8 4/4] sd: change to auto suspend mode
In-Reply-To: <20130201031944.GA6960@aaronlu.sh.intel.com>
Message-ID: <Pine.LNX.4.44L0.1302011011090.1752-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013, Aaron Lu wrote:

> On Thu, Jan 31, 2013 at 10:13:05AM -0500, Alan Stern wrote:
> > On Thu, 31 Jan 2013, Aaron Lu wrote:
> > 
> > > > > +static int scsi_blk_runtime_suspend(struct device *dev)
> > > > > +{
> > > > > +	struct scsi_device *sdev = to_scsi_device(dev);
> > > > 
> > > > For this routine and the other new ones, it may be slightly more
> > > > efficient to pass both dev and sdev as arguments (this depends on how
> > > > smart the compiler's optimizer is).  The caller already knows both of
> > > > them, after all.
> > > 
> > > What about passing only scsi_device? When device is needed, I can use
> > > &sdev->sdev_gendev. Is this equally efficient?
> > 
> > I don't know...  The difference is very small in any case.  The 
> > routines will probably be inlined automatically.
> 
> Indeed, I just checked the .s output of the three cases, they are all
> the same. So we just need to care about readability and less of code,
> passing only scsi_device seems to be the simplest, are you OK with this?

Yes, that's fine.  Thanks for checking it out.

Alan Stern

