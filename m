Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3JWNlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:41:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3JWNlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:41:02 -0400
Date: Wed, 23 Oct 2013 15:40:59 +0200
From: Michal Marek <mmarek@suse.cz>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: Frank Haverkamp <haver@vnet.ibm.com>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver
Message-ID: <20131023134059.GB21936@sepie.suse.cz>
References: <1374740897-20304-1-git-send-email-haver@vnet.ibm.com>
 <1374740897-20304-2-git-send-email-haver@vnet.ibm.com>
 <51F12668.8000400@suse.cz>
 <1382534154.2791.8.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382534154.2791.8.camel@oc7383187364.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 03:15:54PM +0200, Frank Haverkamp wrote:
> Hi Marek,
> 
> it took a little while, but here are the requested changes to our
> driver:
> 
> Rework comments:
>  o Removed __DATE__ macros as suggested by Michal Marek

Hi Frank,

did you send an old version of the patch? There are still two ocurences
of __DATE__:


> +static int genwqe_probe(struct pci_dev *pci_dev,
> +			const struct pci_device_id *id)
> +{
[...]
> +	dev_info(&pci_dev->dev, "GenWQE driver version: %s (build %s) %s%u\n",
> +		 DRV_VERS_STRING, __DATE__, GENWQE_DEVNAME, cd->card_idx);

and

> +static ssize_t show_card_info(struct device *dev,
> +			      struct device_attribute *attr, char *buf)
> +{
[...]
> +	len += scnprintf(&buf[len], PAGE_SIZE - len,
> +			 "GenWQE driver version: %s (build %s)\n"
> +			 "    Device Name/Type: %s %s CardIdx: %d\n"
> +			 "    SLU/APP Config  : 0x%016llx/0x%016llx\n"
> +			 "    Build Date/Type : %u/%x/%u %s\n"
> +			 "    Base Clock      : %u MHz\n"
> +			 "    Arch/SVN Release: %u/%llx\n"
> +			 "    Bitstream       : %llx\n",
> +			 DRV_VERS_STRING, __DATE__, dev_name(&pci_dev->dev),


Thanks,
Michal
