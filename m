Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaKYVpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:45:02 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53603 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaKYVpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:45:00 -0500
Message-ID: <5474F855.7080207@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2014 16:44:53 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
CC: christophe.ricard@gmail.com, josh.triplett@intel.com,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v7 04/10] tpm: rename chip->dev to chip->pdev
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1415713513-16524-5-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1415713513-16524-5-git-send-email-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112521-0033-0000-0000-00000125E2F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 08:45 AM, Jarkko Sakkinen wrote:
> Rename chip->dev to chip->pdev to make it explicit that this not the
> character device but actually represents the platform device.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>


> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 69f4003..b3a7c76 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -98,7 +98,7 @@ struct tpm_vendor_specific {
>   #define TPM_PPI_VERSION_LEN		3
>
>   struct tpm_chip {
> -	struct device *dev;	/* Device stuff */
> +	struct device *pdev;	/* Device stuff */
>   	const struct tpm_class_ops *ops;
>
>   	int dev_num;		/* /dev/tpm# */

So this is the core requiring the renamings.  I assume you got them all 
and none were hidden in #if's or so.

Reviewed-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

