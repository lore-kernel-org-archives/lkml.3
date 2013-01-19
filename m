Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3ASSLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 13:11:47 -0500
Received: from netrider.rowland.org ([192.131.102.5]:53118 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752202Ab3ASSLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 13:11:46 -0500
Date: Sat, 19 Jan 2013 13:11:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Aaron Lu <aaron.lu@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v7 3/4] block: implement runtime pm strategy
In-Reply-To: <50FA3C38.5030308@intel.com>
Message-ID: <Pine.LNX.4.44L0.1301191259040.13032-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jan 2013, Aaron Lu wrote:

> > Okay.  I think you can add (in parentheses) that in most cases drivers
> > should call the routine before any I/O has taken place.
> 
> The reason I put it that way is, in patch 4, the blk_pm_runtime_init is
> called after a request is executed(scsi_probe_lun). I do not want people
> get confused by the comments for blk_pm_runtime_init and the example
> code in patch 4 where we didn't follow it :-)

Right.

> Considering ODD's use case, I was thinking of moving the
> blk_pm_runtime_init call to sd.c, as sr will not use request based auto
> suspend. Probably right before we decrease usage count for the device in
> sd_probe_async. What do you think?

That makes sense.  But then you should review the changes in scsi_pm.c 
to make sure they will work okay for devices that aren't using 
block-layer runtime PM.

Alan Stern

