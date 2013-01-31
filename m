Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3AaPKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:10:03 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51322 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751973Ab3AaPKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:10:00 -0500
Date: Thu, 31 Jan 2013 10:09:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aaron Lu <aaron.lu@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v8 2/4] block: add runtime pm helpers
In-Reply-To: <20130131053535.GA14627@aaronlu.sh.intel.com>
Message-ID: <Pine.LNX.4.44L0.1301311004050.1876-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, Aaron Lu wrote:

> > > +void blk_pm_runtime_init(struct request_queue *q, struct device *dev)
> > > +{
> > > +	q->dev = dev;
> > > +	q->rpm_status = RPM_ACTIVE;
> > > +	pm_runtime_set_autosuspend_delay(q->dev, -1);
> > > +	pm_runtime_use_autosuspend(q->dev);
> > > +	pm_runtime_mark_last_busy(q->dev);
> > > +	pm_runtime_autosuspend(q->dev);
> > 
> > This last line is no longer needed.  It can't do anything useful, since 
> > autosuspends are disabled (the delay is -1).
> 
> Right, thanks.
> And the mark_last_busy can probably be removed too, it didn't make much
> sense here and we can add "driver should call pm_runtime_mark_last_busy
> and pm_runtime_autosuspend in its runtime idle callback" to the kernel
> doc. What do you think?

Yes, okay.

Alan Stern

