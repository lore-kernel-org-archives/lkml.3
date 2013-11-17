Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3KQAYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 19:24:25 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:52939 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3KQAYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 19:24:17 -0500
Date: Sat, 16 Nov 2013 17:24:11 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ashley Lai <adlai@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH 2/5 v2] tpm: Pull everything related to
 sysfs into tpm-sysfs.c
Message-ID: <20131117002411.GB22861@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1383536326-28772-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <1384645999.7518.46.camel@fishsauce>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384645999.7518.46.camel@fishsauce>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 05:53:19PM -0600, Ashley Lai wrote:

> > +/* XXX for now this helper is duplicated in tpm.c */
> 
> I think you mean this is duplicated in tpm-interface.c.  Is there a
> reason why we cannot add this to tpm.h to avoid this duplication?

Indeed, it was called tpm.c when I wrote it :)

I left it because I think there should be a public API to send a
command that makes sense, and transmit_cmd is not good. But, that can
come later, so lets share them for now.

> > +static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
> > +			    int len, const char *desc)
> > +{
> 
> 
> > +static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
> > +			  char *buf)
> 
> Most of the functions in this file are moved from tpm-interface.c
> without any modification to the code.  Why do we need to change the
> function names in this file?  Unless there is a good reason for it
> otherwise I would prefer to keep the same function names.  

When I did the sysfs attribute lists in this file I used the modern
sysfs macros:

>> +static DEVICE_ATTR_RO(pubek);

Which are safer to use, but do require the function name to match
the sysfs file name.

So all sysfs functions must be in the form <FILENAME>_show.

Jason
