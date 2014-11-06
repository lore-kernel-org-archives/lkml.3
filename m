Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaKFI6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:58:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:2943 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbaKFI6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:58:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,324,1413270000"; 
   d="scan'208";a="618076372"
Date: Thu, 6 Nov 2014 10:58:06 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v5 7/7] tpm: create TPM 2.0 devices using own device class
Message-ID: <20141106085805.GA4988@intel.com>
References: <1414832495-23609-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1414832495-23609-8-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141102213305.GB28519@obsidianresearch.com>
 <20141103054101.GA4795@intel.com>
 <20141103213826.GG8303@obsidianresearch.com>
 <1415101654.4115.22.camel@linux.intel.com>
 <20141104181433.GA28387@obsidianresearch.com>
 <20141105074029.GA16217@intel.com>
 <20141105174836.GA5296@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105174836.GA5296@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 10:48:36AM -0700, Jason Gunthorpe wrote:
> On Wed, Nov 05, 2014 at 09:40:29AM +0200, Jarkko Sakkinen wrote:
> 
> > > I mean, if we have a patch that does:
> > > 
> > > struct tpm_chip {
> > >    struct device cdev;  // the class device
> > >    struct device *pdev; // the 'platform' device chip is bound too
> > > 
> > >    struct device *dev = pdev; // Temporary Compatability
> > > [+ device_register/etc/etc]
> > > 
> > > Then both cdev and pdev should always be valid. We should not have cdev
> > > be valid for TPM2 and invalid for TPM1, that is just a big mess.
> 
> > As a first patch I'll do a patch that does dev -> pdev rename and
> > nothing else. IMHO it's clean and easy to review if no other changes
> > are contained. One reason for this is obviously that I want to use
> > cdev for struct cdev not for the class device.
> 
> Well, once you add cdev, pdev and dev, you want most uses of dev to
> become cdev and some uses to become pdev.

struct cdev uses variable name 'cdev' in my previous patch set so 
this naming scheme doesn't work.

I do not understand why dev -> pdev rename as the very first commit
would be such a bad thing. It's anyway better variable name for it.
After that variable name 'dev' is free to be used for class device.

> Just bulk renaming dev -> pdev and then bulk renaming pdev -> cdev
> seems like lots of churn...

I'm not planning to do such thing. In the end there is:

   struct device dev;
   struct device *pdev;
   struct cdev cdev;

This will require only one "rename commit".

What I'm going to take from your feedback is to make /dev/tpm0 special
case when considering major:minor just like you proposed. It's very good
idea.

Other thing I'm going to do is to leave PPI sysfs interface to 
tpmX/device/ppi at least for TPM1 devices.

I'll bake the next patch set hopefully before the end of this week.
Lets see after that if it stil need refinement or breaking up to 
smaller patches.

> Jason

/Jarkko
