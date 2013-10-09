Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3JIPPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:15:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52915 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab3JIPPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:15:13 -0400
Date: Wed, 9 Oct 2013 11:13:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/11] bcma: convert bus code to use dev_groups
Message-ID: <20131009151330.GC14381@tuxdriver.com>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
 <1381128950-28125-7-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1381128950-28125-7-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 11:55:45PM -0700, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct bus_type is going away soon, dev_groups
> should be used instead.  This converts the bcma bus code to use the
> correct field.
> 
> Cc: Rafał Miłecki <zajec5@gmail.com>
> Cc: <linux-wireless@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Rafał, I can take this through my driver-core tree if you like, just let
> me know what would be the easiest for you.

Makes sense to me...

> 
>  drivers/bcma/main.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index 90ee350..e15430a 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -30,28 +30,37 @@ static ssize_t manuf_show(struct device *dev, struct device_attribute *attr, cha
>  	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
>  	return sprintf(buf, "0x%03X\n", core->id.manuf);
>  }
> +static DEVICE_ATTR_RO(manuf);
> +
>  static ssize_t id_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>  	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
>  	return sprintf(buf, "0x%03X\n", core->id.id);
>  }
> +static DEVICE_ATTR_RO(id);
> +
>  static ssize_t rev_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>  	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
>  	return sprintf(buf, "0x%02X\n", core->id.rev);
>  }
> +static DEVICE_ATTR_RO(rev);
> +
>  static ssize_t class_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>  	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
>  	return sprintf(buf, "0x%X\n", core->id.class);
>  }
> -static struct device_attribute bcma_device_attrs[] = {
> -	__ATTR_RO(manuf),
> -	__ATTR_RO(id),
> -	__ATTR_RO(rev),
> -	__ATTR_RO(class),
> -	__ATTR_NULL,
> +static DEVICE_ATTR_RO(class);
> +
> +static struct attribute *bcma_device_attrs[] = {
> +	&dev_attr_manuf.attr,
> +	&dev_attr_id.attr,
> +	&dev_attr_rev.attr,
> +	&dev_attr_class.attr,
> +	NULL,
>  };
> +ATTRIBUTE_GROUPS(bcma_device);
>  
>  static struct bus_type bcma_bus_type = {
>  	.name		= "bcma",
> @@ -59,7 +68,7 @@ static struct bus_type bcma_bus_type = {
>  	.probe		= bcma_device_probe,
>  	.remove		= bcma_device_remove,
>  	.uevent		= bcma_device_uevent,
> -	.dev_attrs	= bcma_device_attrs,
> +	.dev_groups	= bcma_device_groups,
>  };
>  
>  static u16 bcma_cc_core_id(struct bcma_bus *bus)
> -- 
> 1.8.4.6.g82e253f.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
