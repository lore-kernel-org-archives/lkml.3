Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaKJRpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:45:22 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:54960 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbaKJRpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:45:20 -0500
Date: Mon, 10 Nov 2014 10:45:11 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v6 04/10] tpm: rename chip->dev to chip->pdev
Message-ID: <20141110174511.GA5296@obsidianresearch.com>
References: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1415623794-6090-5-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415623794-6090-5-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 02:49:48PM +0200, Jarkko Sakkinen wrote:
> Rename chip->dev to chip->pdev to make it explicit that this not the
> character device but actually represents the platform device.

I don't really have time to take a detailed look at this for a few
weeks, but I like this entire patch set.

 
> -		if (try_module_get(pos->dev->driver->owner)) {
> +		if (try_module_get(pos->pdev->driver->owner)) {
>  			chip = pos;
>  			break;

Yes, this needs to be pdev

>  	if (test_and_set_bit(0, &chip->is_open)) {
> -		dev_dbg(chip->dev, "Another process owns this TPM\n");
> +		dev_dbg(chip->pdev, "Another process owns this TPM\n");
>  		return -EBUSY;

This should be moved to the class dev, ie it should ultimately say dev_dbg(&chip->dev,..

Similar comments all over the place.

Jason
