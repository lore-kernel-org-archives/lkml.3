Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIXR7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:59:45 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:46404 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaIXR7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:59:44 -0400
Date: Wed, 24 Sep 2014 11:59:40 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Message-ID: <20140924175940.GI8898@obsidianresearch.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-13-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20140924171338.GG8898@obsidianresearch.com>
 <54230093.2060303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54230093.2060303@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 01:34:11PM -0400, Stefan Berger wrote:
> On 09/24/2014 01:13 PM, Jason Gunthorpe wrote:
> >On Wed, Sep 24, 2014 at 12:06:02PM +0300, Jarkko Sakkinen wrote:
> >>+static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
> >>+			      char *buf)
> >>+{
> >>+	struct tpm_chip *chip = dev_get_drvdata(dev);
> >>+
> >>+	if (chip->vendor.duration[TPM_LONG] == 0)
> >>+		return 0;
> >>+
> >>+	return sprintf(buf, "%d %d %d [%s]\n",
> >>+		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
> >>+		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
> >>+		       jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
> >>+		       chip->vendor.duration_adjusted
> >>+		       ? "adjusted" : "original");
> >>+}
> >>+static DEVICE_ATTR_RO(durations);
> >Seem useless since the durations are constant, drop it?
> 
> We show them for TPM 1.2 as well, so I'd keep them fo TPM2.

The durations are constant and hardwired in the driver for TPM2, and
the sysfs file format does not follow the one-value-per-file
rule.

So it doesn't display anything useful. In TPM2 mode all the timeouts
are constant and known, so I'd rather see it go away.

> With all the problems we had with TPM 1.2 TPM's wrong timeouts and
> showing them in sysfs, why not show them for TPM2 as well?

We had problems with devices reporting the wrong timeout from their
cap queries - that isn't possible in TPM2.

Both of these values should live in debugfs anyhow.

It would be nice to start with a fresh set of correct sysfs files for
TPM2, since essentially everything is different about the userspace
interface we can safely make a breaking change here.

Jason
