Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaIXUi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:38:29 -0400
Received: from mout.gmx.net ([212.227.17.20]:56495 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaIXUi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:38:28 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Date: Wed, 24 Sep 2014 22:39:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.16.2-dirty; KDE/4.12.5; x86_64; ; )
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com> <54230093.2060303@linux.vnet.ibm.com> <20140924175940.GI8898@obsidianresearch.com>
In-Reply-To: <20140924175940.GI8898@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409242239.41379.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:oN2p7AQbihLalcVckNK5oGJJxHLyqqFDhKZ0k7wfibc59mONK6q
 CpQO5UiPRaE/C2t9DuZ6RxaIGkSj38fRxMsR6GDPR+p34XnwBbS1bYdg+OT0z3wE4byluAs
 GxitoqefaKeoqOZukljJFUbg+Ocn6z35+sT/K/hYf4faWtLBCYnJtxRChFRb00+u6l+we7b
 ucW80icz8UnNOvZFki4Lw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. September 2014, 19:59:40 schrieb Jason Gunthorpe:
> On Wed, Sep 24, 2014 at 01:34:11PM -0400, Stefan Berger wrote:
> > On 09/24/2014 01:13 PM, Jason Gunthorpe wrote:
> > >On Wed, Sep 24, 2014 at 12:06:02PM +0300, Jarkko Sakkinen wrote:
> > >>+static ssize_t durations_show(struct device *dev, struct
> > >>device_attribute *attr, +			      char *buf)
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
> > >
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


If it is more or less a no-op since we have set chip-
>vendor.duration[TPM_SHORT] for other code to work, we can show the values for 
TPM2.0.

However I think we don't need any extra code to show or hide the sysfs files 
for TPM2.0.

Peter
