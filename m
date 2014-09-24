Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaIXUTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:19:49 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:59774 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaIXUTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:19:46 -0400
Date: Wed, 24 Sep 2014 14:19:38 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Message-ID: <20140924201938.GC10887@obsidianresearch.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-13-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20140924171338.GG8898@obsidianresearch.com>
 <20140924190234.GB6801@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924190234.GB6801@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:02:34PM +0300, Jarkko Sakkinen wrote:

> > The pcrs file never conformed to the sysfs rules, if TPM2 is getting a
> > whole new file set, I wouldn't mind seeing it not include the
> > non-conformant ones. What do you think?
> 
> I think that it's better to put extra focus on these sysfs attributes in
> first patch set because it's user space visible. What's wrong in the
> current pcrs file?

Each PCR should be a distinct sysfs file, probably with a
directory. One Value Per File is the rule.

> > > +static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
> > > +			 char *buf)
> > > +{
> > 
> > Ditto.. The manfacturer number should probably be its own file
> 
> Maybe here would make sense to have three files:
> 
> - manufacturer
> - firmware_1
> - firmware_2
> 
> More or less following the name of the TPM properties in the
> specification.

Probably, maybe firmware_1/2 could be combined if they are the same
logical value? (I've always expressed it as firmware_1.firwmare_2?)

> I did not fully understand the comment about tpm2 flag. Why driver
> cannot set it when it initializes the device like with this based
> on value of the STS3?

I was talking about the /dev/ char device - a random application today
will open it and send TPM1 formed messages. Those should be refused
with EINVAL for a TPM2 chip unless the application declares via IOCTL
that it will be sending TPM2 messages.

Otherwise the API contract for the /dev/ device (write TPM1 formed
messages) is broken..

Jason
