Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaKJSDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:03:13 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:59663 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaKJSDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:03:12 -0500
Date: Mon, 10 Nov 2014 11:03:05 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v6 10/10] tpm: TPM 2.0 sysfs attributes
Message-ID: <20141110180305.GC5296@obsidianresearch.com>
References: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1415623794-6090-11-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415623794-6090-11-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 02:49:54PM +0200, Jarkko Sakkinen wrote:

>  	if (len > le32_to_cpu(cca->cmd_size)) {
> -		dev_err(chip->dev,
> +		dev_err(&chip->dev,

Is this out of sequence in the patch series?

>  
>  	rc = tpm2_do_selftest(chip);
> -	if (rc) {
> -		dev_err(dev, "self-test failed\n");
> +	if (rc)
>  		return rc;
> -	}
>  
>  	rc = tpm_chip_register(chip);
> -	if (rc) {
> -		dev_err(dev, "registering the chip failed\n");
> +	if (rc)
>  		return rc;
> -	}

Ditto.

Also, just:

   return tpm_chip_register(chip);

Jason
