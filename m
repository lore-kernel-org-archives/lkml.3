Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3BRVzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 16:55:39 -0500
Received: from netrider.rowland.org ([192.131.102.5]:39425 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756814Ab3BRVzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 16:55:36 -0500
Date: Mon, 18 Feb 2013 16:55:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Aaron Lu <aaron.lu@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v9 4/4] sd: change to auto suspend mode
In-Reply-To: <20130218032039.GA25348@aaronlu.sh.intel.com>
Message-ID: <Pine.LNX.4.44L0.1302181655110.6790-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2013, Aaron Lu wrote:

> Placing a WARN_ON there seems to suggest drivers should not return
> -EAGAIN, so I think I'll just add back those dropped code to
> sdev_runtime_suspend as you have suggested like this:
> 
> static int sdev_runtime_suspend(struct device *dev)
> {
> 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> 	int (*cb)(struct device *) = pm ? pm->runtime_suspend : NULL;
> 	struct scsi_device *sdev = to_scsi_device(dev);
> 	int ret;
> 
> 	if (sdev->request_queue->dev)
> 		return sdev_blk_runtime_suspend(sdev, cb);
> 
> 	ret = scsi_dev_type_suspend(dev, cb);
> 	if (ret == -EAGAIN)
> 		pm_schedule_suspend(dev, jiffies_to_msecs(
> 					round_jiffies_up_relative(HZ/10)));
> 	return ret;
> }
> 
> Does this look OK?

Yes.

Alan Stern

