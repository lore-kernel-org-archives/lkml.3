Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3KQAMz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 19:12:55 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:58370 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3KQAMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 19:12:46 -0500
Date: Sat, 16 Nov 2013 17:12:36 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ashley Lai <adlai@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH 1/5 v2] tpm: Pull everything related to
 /dev/tpmX into tpm-dev.c
Message-ID: <20131117001236.GA22861@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1383536326-28772-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <1384640335.7518.12.camel@fishsauce>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384640335.7518.12.camel@fishsauce>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 04:18:55PM -0600, Ashley Lai wrote:
> Nice clean up!!! The code looks much more clean after removing the
> duplicated code in all drivers.  Thanks.

> > +++ b/drivers/char/tpm/tpm-dev.c
> > + * Copyright (C) 2013 Obsidian Reearch Corp
> 
> Typo Research?

Yes, thanks :)
 
> > + * Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > + *
> 
> > +
> > +int tpm_dev_add_device(struct tpm_chip *chip)
> > +{
> 
> > +	rc = misc_register(&chip->vendor.miscdev);
> > +	if (rc) {
> > +		chip->vendor.miscdev.name = NULL;
> > +		dev_warn(chip->dev,
> 
> Any reason why we use dev_warn here instead of dev_err?

Indeed, it was dev_err before I moved it. 

Hmm, it has been so long.. I think an earlier draft had
tpm_dev_add_device return void (like in other subsystems), so warn
made more sense. However I eventually changed it to propogate errors,
and didn't catch the flip.

Lets put it back.

Thanks!
Jason
