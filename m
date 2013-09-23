Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab3IWSwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:52:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38693 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3IWSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:52:45 -0400
Date: Mon, 23 Sep 2013 14:51:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>
Subject: Re: [PATCH 03/13] tpm: xen-tpmfront: Fix default durations
Message-ID: <20130923185158.GA2507@phenom.dumpdata.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1379960083-8942-4-git-send-email-jgunthorpe@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379960083-8942-4-git-send-email-jgunthorpe@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 12:14:33PM -0600, Jason Gunthorpe wrote:
> All the default durations were being set to 10 minutes which is
> way too long for the timeouts. Normal values for the longest
> duration are around 5 mins, and short duration ar around .5s.
> 
> Further, these are just the default, tpm_get_timeouts will set
> them to values from the TPM (or throw an error).
> 
> Just remove them.

Sounds sensible.

Daniel?

> 
> Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/char/tpm/xen-tpmfront.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
> index 7a7929b..6f2fe2b 100644
> --- a/drivers/char/tpm/xen-tpmfront.c
> +++ b/drivers/char/tpm/xen-tpmfront.c
> @@ -210,8 +210,6 @@ static struct attribute_group vtpm_attr_grp = {
>  	.attrs = vtpm_attrs,
>  };
>  
> -#define TPM_LONG_TIMEOUT   (10 * 60 * HZ)
> -
>  static const struct tpm_vendor_specific tpm_vtpm = {
>  	.status = vtpm_status,
>  	.recv = vtpm_recv,
> @@ -224,11 +222,6 @@ static const struct tpm_vendor_specific tpm_vtpm = {
>  	.miscdev = {
>  		.fops = &vtpm_ops,
>  	},
> -	.duration = {
> -		TPM_LONG_TIMEOUT,
> -		TPM_LONG_TIMEOUT,
> -		TPM_LONG_TIMEOUT,
> -	},
>  };
>  
>  static irqreturn_t tpmif_interrupt(int dummy, void *dev_id)
> -- 
> 1.8.1.2
> 
