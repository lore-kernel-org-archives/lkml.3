Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3AaPNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:13:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51335 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752469Ab3AaPNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:13:06 -0500
Date: Thu, 31 Jan 2013 10:13:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aaron Lu <aaron.lu@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v8 4/4] sd: change to auto suspend mode
In-Reply-To: <20130131054324.GB14627@aaronlu.sh.intel.com>
Message-ID: <Pine.LNX.4.44L0.1301311010200.1876-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, Aaron Lu wrote:

> > > +static int scsi_blk_runtime_suspend(struct device *dev)
> > > +{
> > > +	struct scsi_device *sdev = to_scsi_device(dev);
> > 
> > For this routine and the other new ones, it may be slightly more
> > efficient to pass both dev and sdev as arguments (this depends on how
> > smart the compiler's optimizer is).  The caller already knows both of
> > them, after all.
> 
> What about passing only scsi_device? When device is needed, I can use
> &sdev->sdev_gendev. Is this equally efficient?

I don't know...  The difference is very small in any case.  The 
routines will probably be inlined automatically.

> > > +		if (sdev->request_queue->dev) {
> > > +			pm_runtime_mark_last_busy(dev);
> > > +			err = pm_runtime_autosuspend(dev);
> > > +		} else {
> > > +			err = pm_schedule_suspend(dev, 100);
> > > +		}
> > > +	} else {
> > >  		err = pm_runtime_suspend(dev);
> > > +	}
> > >  	return err;
> 
> Shall we ignore the return value for these pm_xxx_suspend functions?
> I mean we do not need to record the return value for them and return it,
> since pm core doesn't care the return value of idle callback.

Maybe it will care in a future kernel version.  You might as well store 
the return code and pass it back.

Alan Stern


