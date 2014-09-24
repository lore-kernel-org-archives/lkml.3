Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaIXSu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:50:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:48346 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbaIXSu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:50:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="479770845"
Date: Wed, 24 Sep 2014 21:50:14 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Message-ID: <20140924185014.GA6801@intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-13-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20140924171338.GG8898@obsidianresearch.com>
 <54230093.2060303@linux.vnet.ibm.com>
 <20140924175940.GI8898@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924175940.GI8898@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:59:40AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 24, 2014 at 01:34:11PM -0400, Stefan Berger wrote:
> > On 09/24/2014 01:13 PM, Jason Gunthorpe wrote:
> > >On Wed, Sep 24, 2014 at 12:06:02PM +0300, Jarkko Sakkinen wrote:
> > >>+static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
> > >>+			      char *buf)
> > >>+{
> > >>+	struct tpm_chip *chip = dev_get_drvdata(dev);
> > >>+
> > >>+	if (chip->vendor.duration[TPM_LONG] == 0)
> > >>+		return 0;
> > >>+
> > >>+	return sprintf(buf, "%d %d %d [%s]\n",
> > >>+		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
> > >>+		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
> > >>+		       jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
> > >>+		       chip->vendor.duration_adjusted
> > >>+		       ? "adjusted" : "original");
> > >>+}
> > >>+static DEVICE_ATTR_RO(durations);
> > >Seem useless since the durations are constant, drop it?
> > 
> > We show them for TPM 1.2 as well, so I'd keep them fo TPM2.
> 
> The durations are constant and hardwired in the driver for TPM2, and
> the sysfs file format does not follow the one-value-per-file
> rule.
> 
> So it doesn't display anything useful. In TPM2 mode all the timeouts
> are constant and known, so I'd rather see it go away.
> 
> > With all the problems we had with TPM 1.2 TPM's wrong timeouts and
> > showing them in sysfs, why not show them for TPM2 as well?
> 
> We had problems with devices reporting the wrong timeout from their
> cap queries - that isn't possible in TPM2.
> 
> Both of these values should live in debugfs anyhow.
> 
> It would be nice to start with a fresh set of correct sysfs files for
> TPM2, since essentially everything is different about the userspace
> interface we can safely make a breaking change here.

I'll drop timeouts and durations. It's easy to add them later if they
are needed.

> Jason

/Jarkko
