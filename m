Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3IWVUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:20:23 -0400
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:57803 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753938Ab3IWVTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:19:14 -0400
X-TM-IMSS-Message-ID: <2e1aacb400025e52@nsa.gov>
Message-ID: <5240B022.70000@tycho.nsa.gov>
Date: Mon, 23 Sep 2013 17:18:26 -0400
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Rajiv Andrade <mail@srajiv.net>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [PATCH] tpm: xen-tpmfront: Remove the locality sysfs attribute
References: <20130923205415.GC16345@obsidianresearch.com>
In-Reply-To: <20130923205415.GC16345@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 04:54 PM, Jason Gunthorpe wrote:
> Upon deeper review it was agreed to remove the driver-unique
> 'locality' sysfs attribute before it is present in a released
> kernel.
>
> The attribute was introduced in e2683957fb268c6b29316fd9e7191e13239a30a5
> during the 3.12 merge window, so this patch needs to go in before
> 3.12 is released.
>
> The hope is to have a well defined locality API that all the other
> locality aware drivers can use, perhaps in 3.13.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>   drivers/char/tpm/xen-tpmfront.c | 29 -----------------------------
>   1 file changed, 29 deletions(-)
>
> Daniel, if you can Ack this..

Acked-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>

> Konrad: This driver was originally merged through you, can you
> pick this up?
>
> Regards,
> Jason
>
> diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
> index 6f2fe2b..06189e5 100644
> --- a/drivers/char/tpm/xen-tpmfront.c
> +++ b/drivers/char/tpm/xen-tpmfront.c
> @@ -142,32 +142,6 @@ static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>   	return length;
>   }
>
> -ssize_t tpm_show_locality(struct device *dev, struct device_attribute *attr,
> -			  char *buf)
> -{
> -	struct tpm_chip *chip = dev_get_drvdata(dev);
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> -	u8 locality = priv->shr->locality;
> -
> -	return sprintf(buf, "%d\n", locality);
> -}
> -
> -ssize_t tpm_store_locality(struct device *dev, struct device_attribute *attr,
> -			const char *buf, size_t len)
> -{
> -	struct tpm_chip *chip = dev_get_drvdata(dev);
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> -	u8 val;
> -
> -	int rv = kstrtou8(buf, 0, &val);
> -	if (rv)
> -		return rv;
> -
> -	priv->shr->locality = val;
> -
> -	return len;
> -}
> -
>   static const struct file_operations vtpm_ops = {
>   	.owner = THIS_MODULE,
>   	.llseek = no_llseek,
> @@ -188,8 +162,6 @@ static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
>   static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
>   static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
>   static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
> -static DEVICE_ATTR(locality, S_IRUGO | S_IWUSR, tpm_show_locality,
> -		tpm_store_locality);
>
>   static struct attribute *vtpm_attrs[] = {
>   	&dev_attr_pubek.attr,
> @@ -202,7 +174,6 @@ static struct attribute *vtpm_attrs[] = {
>   	&dev_attr_cancel.attr,
>   	&dev_attr_durations.attr,
>   	&dev_attr_timeouts.attr,
> -	&dev_attr_locality.attr,
>   	NULL,
>   };
>
>


-- 
Daniel De Graaf
National Security Agency
