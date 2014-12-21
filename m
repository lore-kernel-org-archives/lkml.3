Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaLUEFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 23:05:41 -0500
Received: from ozlabs.org ([103.22.144.67]:59151 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbaLUEFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 23:05:40 -0500
Message-ID: <1419134735.27324.41.camel@neuling.org>
Subject: Re: [PATCH] misc: cxl: sysfs.c:  Remove unused function
From: Michael Neuling <mikey@neuling.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Sun, 21 Dec 2014 15:05:35 +1100
In-Reply-To: <1419092024-6701-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419092024-6701-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove the function mmio_size_show() that is not used anywhere.

Did you compile check this patch?

  drivers/misc/cxl/sysfs.c:291:74: error: ‘mmio_size_show’ undeclared here (not in a function)

It's used here:
        static struct device_attribute afu_attrs[] = {
        	__ATTR_RO(mmio_size),

> This was partially found by using a static code analysis program called cppcheck.

Thanks for letting me know which tool to avoid :-)

Mikey


> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/misc/cxl/sysfs.c |   11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/drivers/misc/cxl/sysfs.c b/drivers/misc/cxl/sysfs.c
> index ce7ec06..0431ec3 100644
> --- a/drivers/misc/cxl/sysfs.c
> +++ b/drivers/misc/cxl/sysfs.c
> @@ -102,17 +102,6 @@ static struct device_attribute afu_master_attrs[] = {
>  
>  /*********  AFU attributes  **************************************************/
>  
> -static ssize_t mmio_size_show(struct device *device,
> -			      struct device_attribute *attr,
> -			      char *buf)
> -{
> -	struct cxl_afu *afu = to_cxl_afu(device);
> -
> -	if (afu->pp_size)
> -		return scnprintf(buf, PAGE_SIZE, "%llu\n", afu->pp_size);
> -	return scnprintf(buf, PAGE_SIZE, "%llu\n", afu->adapter->ps_size);
> -}
> -
>  static ssize_t reset_store_afu(struct device *device,
>  			       struct device_attribute *attr,
>  			       const char *buf, size_t count)

