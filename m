Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaK0Ovj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:51:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:16421 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaK0Ovh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:51:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,469,1413270000"; 
   d="scan'208";a="615043962"
Date: Thu, 27 Nov 2014 16:51:31 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, christophe.ricard@gmail.com,
        josh.triplett@intel.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v7 04/10] tpm: rename chip->dev to
 chip->pdev
Message-ID: <20141127145111.GC24791@intel.com>
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1415713513-16524-5-git-send-email-jarkko.sakkinen@linux.intel.com>
 <5474F855.7080207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5474F855.7080207@linux.vnet.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 04:44:53PM -0500, Stefan Berger wrote:
> On 11/11/2014 08:45 AM, Jarkko Sakkinen wrote:
> >Rename chip->dev to chip->pdev to make it explicit that this not the
> >character device but actually represents the platform device.
> >
> >Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> >
> 
> 
> >diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> >index 69f4003..b3a7c76 100644
> >--- a/drivers/char/tpm/tpm.h
> >+++ b/drivers/char/tpm/tpm.h
> >@@ -98,7 +98,7 @@ struct tpm_vendor_specific {
> >  #define TPM_PPI_VERSION_LEN		3
> >
> >  struct tpm_chip {
> >-	struct device *dev;	/* Device stuff */
> >+	struct device *pdev;	/* Device stuff */
> >  	const struct tpm_class_ops *ops;
> >
> >  	int dev_num;		/* /dev/tpm# */
> 
> So this is the core requiring the renamings.  I assume you got them all and
> none were hidden in #if's or so.

Yup, I basically did :argdo %s/chip->dev/chip->pdev/g for *.[ch].

> Reviewed-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

/Jarkko
