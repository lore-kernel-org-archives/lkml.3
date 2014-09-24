Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaIXTax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:30:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:27140 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbaIXTav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:30:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="578420050"
Date: Wed, 24 Sep 2014 22:30:21 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org,
        Will Arthur <will.c.arthur@intel.com>
Subject: Re: [PATCH v1 10/12] tpm: TPM 2.0 FIFO Interface
Message-ID: <20140924193021.GD6801@intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-11-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20140924165921.GE8898@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924165921.GE8898@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:59:21AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 24, 2014 at 12:06:00PM +0300, Jarkko Sakkinen wrote:
>   
> > -	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
> > +	chip = tpm_chip_alloc(dev, &tpm_tis);
> > +	if (!chip)
> >  		return -ENODEV;
> 
> Please put this in a separate patch, don't co-mingle it with TPM2
> support. If drivers are going to be converted, then I want to see the
> new API used properly and the driver itself to be a *correct* example
> of using the new API.

Agreed.

> So you have to purge the tis_chips, fix the missing removal functions,
> call unregister, fix the force probe path, etc.
> 
> >  	chip->vendor.iobase = ioremap(start, len);
> 
> Since this changes the ordering, can we devm this ioremap?

Hmm... I was going to do that but forgot it. I'll add this to my
backlog.

> Jason
/Jarkko
