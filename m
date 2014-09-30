Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaI3UMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:12:16 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:49383 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaI3UMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:12:15 -0400
Date: Tue, 30 Sep 2014 14:12:09 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Message-ID: <20140930201209.GD30200@obsidianresearch.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20140924190234.GB6801@intel.com>
 <20140924201938.GC10887@obsidianresearch.com>
 <201409242235.42286.PeterHuewe@gmx.de>
 <20140924204627.GA12407@obsidianresearch.com>
 <20140926171947.GA5611@intel.com>
 <20140930200721.GA8069@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930200721.GA8069@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 11:07:21PM +0300, Jarkko Sakkinen wrote:
> On Fri, Sep 26, 2014 at 08:19:47PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Sep 24, 2014 at 02:46:27PM -0600, Jason Gunthorpe wrote:
> > > > That would be 24*2 files only for pcrs...
> > > 
> > > Some subsystems do just that..
> > > 
> > > $ ls /sys/class/infiniband/qib0/ports/1/sl2vl/
> > > 0  1  10  11  12  13  14  15  2  3  4  5  6  7  8  9
> > 
> > They use static structures in
> > drivers/infiniband/hw/qib/qib_sysfs.c and it does not looks a
> > mess. I would prefer to create struct attribute entries
> > dynamically if there's clean and easy way to do that.
> 
> I gave this a shot:
> 
> https://github.com/jsakkine/linux-tpm2/commit/dffce68ce34da265a62908dec71b2d85fc16824f
> 
> I want to initialize dynamically so that it is easy to support
> TPM_PT_PCR_COUNT later.

You can't use a static pcr_dev_attrs, this has to be allocated in the
chip structure (because of the NULL). Otherwise looks about right
(although there are more problematic core details here, like racing of the
tpm dev create with the creation of the sysfs files)

Do you have a reason to have the pcrs in sysfs? I'd be just as happy
to see them dropped or moved to debugfs for TPM2 as well.

Jason
