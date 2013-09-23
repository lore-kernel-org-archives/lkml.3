Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3IWTgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:36:44 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:45502 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab3IWTgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:36:43 -0400
Date: Mon, 23 Sep 2013 13:36:33 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Cc: tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to
 sysfs into tpm-sysfs.c
Message-ID: <20130923193633.GA9194@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1379960083-8942-10-git-send-email-jgunthorpe@obsidianresearch.com>
 <52408E5D.4020904@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52408E5D.4020904@tycho.nsa.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 02:54:21PM -0400, Daniel De Graaf wrote:
> On 09/23/2013 02:14 PM, Jason Gunthorpe wrote:
> >CLASS-sysfs.c is a common idiom for linux subsystems.
> >
> >This pulls all the sysfs attribute functions and related code
> >into tpm-sysfs.c. To support this change some constants are moved
> >from tpm.c to tpm.h and __tpm_pcr_read is made non-static and is
> >called tpm_pcr_read_dev.
> >
> >Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> [...]
> >diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
> >index 12a4ab2..7892557 100644
> >+++ b/drivers/char/tpm/xen-tpmfront.c
> [...]
> >-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
> >-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
> >-static DEVICE_ATTR(locality, S_IRUGO | S_IWUSR, tpm_show_locality,
> >-		tpm_store_locality);
> 
> This patch drops the "locality" sysfs attribute from xen-tpmfront. Since
> that attribute is currently only implemented for the xen TPM driver, it
> is best to leave it there for now (and its show/store functions could
> also be made static, an oversight I just noticed now). If this attribute
> is later made available on other TPM drivers, it may need to contain
> device-specific logic, but such an implementation is well outside the
> scope of this series.

Okay, I see what you are talking about, the compiler didn't warn
because of the missing static.

This really is a core functionality. Lots of other drivers support
locality, but none have dared actually expose the functionality. IHMO,
it is a mistake to just jam a locality attribute in one driver.

Sorry, I would have said something when the driver was posted if it
was obvious this was hiding in there :|

It looks like this driver was introduced in the 3.12 merge window, we
could drop the attribute, and try to merge a core supported locality
API in 3.13? What do you think?

But, if you say it is needed, it is easy enough to adjust this patch
series.

Thanks,
Jason
