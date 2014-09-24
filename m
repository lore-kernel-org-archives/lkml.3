Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaIXQ7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:59:31 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:40930 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbaIXQ7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:59:30 -0400
Date: Wed, 24 Sep 2014 10:59:21 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org,
        Will Arthur <will.c.arthur@intel.com>
Subject: Re: [PATCH v1 10/12] tpm: TPM 2.0 FIFO Interface
Message-ID: <20140924165921.GE8898@obsidianresearch.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-11-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411549562-24242-11-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:06:00PM +0300, Jarkko Sakkinen wrote:
  
> -	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
> +	chip = tpm_chip_alloc(dev, &tpm_tis);
> +	if (!chip)
>  		return -ENODEV;

Please put this in a separate patch, don't co-mingle it with TPM2
support. If drivers are going to be converted, then I want to see the
new API used properly and the driver itself to be a *correct* example
of using the new API.

So you have to purge the tis_chips, fix the missing removal functions,
call unregister, fix the force probe path, etc.

>  	chip->vendor.iobase = ioremap(start, len);

Since this changes the ordering, can we devm this ioremap?

Jason
