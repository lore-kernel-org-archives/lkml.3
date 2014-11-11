Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaKKINj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:13:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:17312 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaKKINh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:13:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,359,1413270000"; 
   d="scan'208";a="634922216"
Date: Tue, 11 Nov 2014 10:13:31 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v6 04/10] tpm: rename chip->dev to chip->pdev
Message-ID: <20141111081331.GA7088@intel.com>
References: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1415623794-6090-5-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141110174511.GA5296@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110174511.GA5296@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 10:45:11AM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 10, 2014 at 02:49:48PM +0200, Jarkko Sakkinen wrote:
> > Rename chip->dev to chip->pdev to make it explicit that this not the
> > character device but actually represents the platform device.
> 
> I don't really have time to take a detailed look at this for a few
> weeks, but I like this entire patch set.

Excellent, thank you.

> > -		if (try_module_get(pos->dev->driver->owner)) {
> > +		if (try_module_get(pos->pdev->driver->owner)) {
> >  			chip = pos;
> >  			break;
> 
> Yes, this needs to be pdev
> 
> >  	if (test_and_set_bit(0, &chip->is_open)) {
> > -		dev_dbg(chip->dev, "Another process owns this TPM\n");
> > +		dev_dbg(chip->pdev, "Another process owns this TPM\n");
> >  		return -EBUSY;
> 
> This should be moved to the class dev, ie it should ultimately say
> dev_dbg(&chip->dev,..

Peter, I'll try to minimize the delta between the patch set revisions
so that this could be pulled in the near future (maybe having odds
to make into 3.19) and do only fixes to those issues that are blockers.

Would you mind if I fixed dev logging stuff after the patch set has
been pulled? 

Writing this down anyway to my backlog.

> Similar comments all over the place.
> 
> Jason

/Jarkko
