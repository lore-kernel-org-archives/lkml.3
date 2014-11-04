Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaKDXBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:01:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:34212 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbaKDXBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:01:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411491945"
Date: Wed, 5 Nov 2014 01:00:50 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v5 7/7] tpm: create TPM 2.0 devices using own device class
Message-ID: <20141104230050.GB9246@intel.com>
References: <1414832495-23609-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1414832495-23609-8-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141102213305.GB28519@obsidianresearch.com>
 <20141103054101.GA4795@intel.com>
 <20141103213826.GG8303@obsidianresearch.com>
 <1415101654.4115.22.camel@linux.intel.com>
 <20141104181433.GA28387@obsidianresearch.com>
 <20141104203843.GA7115@intel.com>
 <20141104204918.GB3583@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104204918.GB3583@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 01:49:18PM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 04, 2014 at 10:38:43PM +0200, Jarkko Sakkinen wrote:
> 
> > > Then a patch: Drop misc_register entirely, no compat stuff. Explain
> > > clearly the resulting sysfs changes, CC the various people who monitor
> > > the sysfs API, act on any feedback. I'm hoping it is an OK change.
> > > [ If it is not OK then we can talk about using it only for TPM2 or
> > >   whatever ]
> > 
> > Hold on. So you are proposing that for a TPM 1.0 device you would
> > have simultaneously as an intermediate step:
> > 
> > - /sys/class/tpm/tpm0
> > - /sys/class/misc/tpm0
> 
> Yes, well more specifically:
> 
> /sys/class/tpm/tpm0/
> /sys/class/misc/tpm0/dev
> 
> The reason for this is simply that adding to sysfs is certainly OK,
> I don't think the tpm and misc device will collide in any way - udev
> will look for the 'dev' file and ignore the class/tpm directory.
> 
> It breaks up the patch too, this would be a monster:
> 
> > Maybe it would be a better idea to just create patch that would simply
> 
> Because of all the variable rename noise and so forth.
> 
> Even if the net result is we apply several patchs in a row that wipes
> /sys/class/misc/tpm0 the patches themselves will be smaller and more
> reviewable if split, especially those big variable rename ones..

OK, I see your point. I'll break it up into more reasonable steps.

> > Moving the current TPM sysfs attributes is not really an issue because
> > they are only for human consumption (not machine readable in any sany
> > way) :) And AFAIK TrouSerS does not use sysfs PPI interface.
> 
> Someone in user space must use that event log and PPI stuff??? Does
> anyone know who and how?
> 
> Jason

/Jarkko
