Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaI3UHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:07:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:65031 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbaI3UHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:07:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,628,1406617200"; 
   d="scan'208";a="581484247"
Date: Tue, 30 Sep 2014 23:07:21 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Message-ID: <20140930200721.GA8069@intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20140924190234.GB6801@intel.com>
 <20140924201938.GC10887@obsidianresearch.com>
 <201409242235.42286.PeterHuewe@gmx.de>
 <20140924204627.GA12407@obsidianresearch.com>
 <20140926171947.GA5611@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926171947.GA5611@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 08:19:47PM +0300, Jarkko Sakkinen wrote:
> On Wed, Sep 24, 2014 at 02:46:27PM -0600, Jason Gunthorpe wrote:
> > > That would be 24*2 files only for pcrs...
> > 
> > Some subsystems do just that..
> > 
> > $ ls /sys/class/infiniband/qib0/ports/1/sl2vl/
> > 0  1  10  11  12  13  14  15  2  3  4  5  6  7  8  9
> 
> They use static structures in drivers/infiniband/hw/qib/qib_sysfs.c
> and it does not looks a mess. I would prefer to create struct attribute
> entries dynamically if there's clean and easy way to do that.

I gave this a shot:

https://github.com/jsakkine/linux-tpm2/commit/dffce68ce34da265a62908dec71b2d85fc16824f

I want to initialize dynamically so that it is easy to support 
TPM_PT_PCR_COUNT later.

/Jarkko
