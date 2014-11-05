Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbaKERsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:48:55 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:58136 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaKERsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:48:53 -0500
Date: Wed, 5 Nov 2014 10:48:36 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v5 7/7] tpm: create TPM 2.0 devices using own device class
Message-ID: <20141105174836.GA5296@obsidianresearch.com>
References: <1414832495-23609-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1414832495-23609-8-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141102213305.GB28519@obsidianresearch.com>
 <20141103054101.GA4795@intel.com>
 <20141103213826.GG8303@obsidianresearch.com>
 <1415101654.4115.22.camel@linux.intel.com>
 <20141104181433.GA28387@obsidianresearch.com>
 <20141105074029.GA16217@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105074029.GA16217@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 09:40:29AM +0200, Jarkko Sakkinen wrote:

> > I mean, if we have a patch that does:
> > 
> > struct tpm_chip {
> >    struct device cdev;  // the class device
> >    struct device *pdev; // the 'platform' device chip is bound too
> > 
> >    struct device *dev = pdev; // Temporary Compatability
> > [+ device_register/etc/etc]
> > 
> > Then both cdev and pdev should always be valid. We should not have cdev
> > be valid for TPM2 and invalid for TPM1, that is just a big mess.

> As a first patch I'll do a patch that does dev -> pdev rename and
> nothing else. IMHO it's clean and easy to review if no other changes
> are contained. One reason for this is obviously that I want to use
> cdev for struct cdev not for the class device.

Well, once you add cdev, pdev and dev, you want most uses of dev to
become cdev and some uses to become pdev.

Just bulk renaming dev -> pdev and then bulk renaming pdev -> cdev
seems like lots of churn...

Jason
