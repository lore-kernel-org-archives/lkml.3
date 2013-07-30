Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3G3S1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:27:11 -0400
Received: from mx2.parallels.com ([199.115.105.18]:33150 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3G3S1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:27:08 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-15?Q?Kai_M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 26/36] SCSI: st: convert class code to use dev_groups
Thread-Topic: [PATCH 26/36] SCSI: st: convert class code to use dev_groups
Thread-Index: AQHOiLn9t/l1qhKVW06gF3VbaQ7jyJl+CK4A
Date: Tue, 30 Jul 2013 18:27:06 +0000
Message-ID: <1375208826.2065.12.camel@dabdike.int.hansenpartnership.com>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
	 <1374703539-9705-27-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1374703539-9705-27-git-send-email-gregkh@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.17.213.192]
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <729B32817221F54798078068CC3F9F2D@sw.swsoft.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding linux-scsi to cc.

James

On Wed, 2013-07-24 at 15:05 -0700, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the scsi tape class code to use
> the correct field.
> 
> Cc: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> James, feel free to take this through your tree, or ACK it and I can
> take it through mine.
> 
>  drivers/scsi/st.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 2a32036a..ff44b3c2 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -82,7 +82,7 @@ static int try_rdio = 1;
>  static int try_wdio = 1;
>  
>  static struct class st_sysfs_class;
> -static struct device_attribute st_dev_attrs[];
> +static const struct attribute_group *st_dev_groups[];
>  
>  MODULE_AUTHOR("Kai Makisara");
>  MODULE_DESCRIPTION("SCSI tape (st) driver");
> @@ -4274,7 +4274,7 @@ static void scsi_tape_release(struct kref *kref)
>  
>  static struct class st_sysfs_class = {
>  	.name = "scsi_tape",
> -	.dev_attrs = st_dev_attrs,
> +	.dev_groups = st_dev_groups,
>  };
>  
>  static int __init init_st(void)
> @@ -4408,6 +4408,7 @@ defined_show(struct device *dev, struct device_attribute *attr, char *buf)
>  	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->defined);
>  	return l;
>  }
> +static DEVICE_ATTR_RO(defined);
>  
>  static ssize_t
>  default_blksize_show(struct device *dev, struct device_attribute *attr,
> @@ -4419,7 +4420,7 @@ default_blksize_show(struct device *dev, struct device_attribute *attr,
>  	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->default_blksize);
>  	return l;
>  }
> -
> +static DEVICE_ATTR_RO(default_blksize);
>  
>  static ssize_t
>  default_density_show(struct device *dev, struct device_attribute *attr,
> @@ -4433,6 +4434,7 @@ default_density_show(struct device *dev, struct device_attribute *attr,
>  	l = snprintf(buf, PAGE_SIZE, fmt, STm->default_density);
>  	return l;
>  }
> +static DEVICE_ATTR_RO(default_density);
>  
>  static ssize_t
>  default_compression_show(struct device *dev, struct device_attribute *attr,
> @@ -4444,6 +4446,7 @@ default_compression_show(struct device *dev, struct device_attribute *attr,
>  	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->default_compression - 1);
>  	return l;
>  }
> +static DEVICE_ATTR_RO(default_compression);
>  
>  static ssize_t
>  options_show(struct device *dev, struct device_attribute *attr, char *buf)
> @@ -4472,15 +4475,17 @@ options_show(struct device *dev, struct device_attribute *attr, char *buf)
>  	l = snprintf(buf, PAGE_SIZE, "0x%08x\n", options);
>  	return l;
>  }
> -
> -static struct device_attribute st_dev_attrs[] = {
> -	__ATTR_RO(defined),
> -	__ATTR_RO(default_blksize),
> -	__ATTR_RO(default_density),
> -	__ATTR_RO(default_compression),
> -	__ATTR_RO(options),
> -	__ATTR_NULL,
> +static DEVICE_ATTR_RO(options);
> +
> +static struct attribute *st_dev_attrs[] = {
> +	&dev_attr_defined.attr,
> +	&dev_attr_default_blksize.attr,
> +	&dev_attr_default_density.attr,
> +	&dev_attr_default_compression.attr,
> +	&dev_attr_options.attr,
> +	NULL,
>  };
> +ATTRIBUTE_GROUPS(st_dev);
>  
>  /* The following functions may be useful for a larger audience. */
>  static int sgl_map_user_pages(struct st_buffer *STbp,


