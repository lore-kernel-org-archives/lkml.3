Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab3ARP0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:26:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43572 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750937Ab3ARP0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:26:38 -0500
Date: Fri, 18 Jan 2013 10:26:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aaron Lu <aaron.lu@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v7 3/4] block: implement runtime pm strategy
In-Reply-To: <20130118082720.GA12599@aaronlu.sh.intel.com>
Message-ID: <Pine.LNX.4.44L0.1301181024340.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013, Aaron Lu wrote:

> > Either you have to make sure the q->nr_pending is always correct, even 
> > when runtime PM isn't being used, or else the caller has to make sure 
> > that no I/O takes place before blk_pm_runtime_init is called.
> 
> I think we can say:
> blk_pm_runtime_init can't be called after any requests have been
> submitted but not finished.
> Sounds more accurate?

Okay.  I think you can add (in parentheses) that in most cases drivers
should call the routine before any I/O has taken place.

Alan Stern

