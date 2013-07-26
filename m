Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab3GZJiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:38:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3GZJiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:38:07 -0400
Message-ID: <51F24379.6020708@linux-pingi.de>
Date: Fri, 26 Jul 2013 11:38:01 +0200
From: Karsten Keil <kkeil@linux-pingi.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>
Subject: Re: [PATCH 09/36] ISDN: convert class code to use dev_groups
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org> <1374703539-9705-10-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1374703539-9705-10-git-send-email-gregkh@linuxfoundation.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:OLWMdak4WRd90Ei2YnFOKXS8KcF7R/aZXgJRQ1OLZro
 OyuOLHstni1frMkVtDEBiEq7NMLzWNGXjEHOC72Th0FwvDSrz1
 o1hAmD2ECK6Ti2w2CzgwkZyJYfTAnaw7DDiezcPiHLQGf/kWk9
 mQCe6aELsv1uZoz30FhcgpmCpNCvLSb6maIopN5mVj91Rfkzn1
 YuPpKu9QBqzqv8TfgQDSOdjUXExKIcBqm9PVspl3JoVva3j2UH
 Wn5eSVpmBMsJuWXMsYy8JfaIkhO5TlWx72WCHaVLrxHIsk7zC0
 ZjdjeQ0Vm8ntOlwyM138EpybougfA2YEf2txbfjwrsbnFEAPhE
 XkrrTKbKxqnijn8yXjPkMdXOobpVcQw3vrU4Cdd3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.07.2013 00:05, schrieb Greg Kroah-Hartman:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the mISDN class code to use the
> correct field.
> 
> Cc: Karsten Keil <isdn@linux-pingi.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Karsten Keil <isdn@linux-pingi.de>

> ---
> 
> Karsten, feel free to apply this to your tree, or ACK it and I can take it
> through mine.
> 
>  drivers/isdn/mISDN/core.c | 64 ++++++++++++++++++++++++++---------------------
>  1 file changed, 36 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
> index da30c5cb..faf50546 100644
> --- a/drivers/isdn/mISDN/core.c
> +++ b/drivers/isdn/mISDN/core.c
> @@ -37,8 +37,8 @@ static void mISDN_dev_release(struct device *dev)
>  	/* nothing to do: the device is part of its parent's data structure */
>  }
>  
> -static ssize_t _show_id(struct device *dev,
> -			struct device_attribute *attr, char *buf)
> +static ssize_t id_show(struct device *dev,
> +		       struct device_attribute *attr, char *buf)
>  {
>  	struct mISDNdevice *mdev = dev_to_mISDN(dev);
>  
> @@ -46,9 +46,10 @@ static ssize_t _show_id(struct device *dev,
>  		return -ENODEV;
>  	return sprintf(buf, "%d\n", mdev->id);
>  }
> +static DEVICE_ATTR_RO(id);
>  
> -static ssize_t _show_nrbchan(struct device *dev,
> -			     struct device_attribute *attr, char *buf)
> +static ssize_t nrbchan_show(struct device *dev,
> +			    struct device_attribute *attr, char *buf)
>  {
>  	struct mISDNdevice *mdev = dev_to_mISDN(dev);
>  
> @@ -56,9 +57,10 @@ static ssize_t _show_nrbchan(struct device *dev,
>  		return -ENODEV;
>  	return sprintf(buf, "%d\n", mdev->nrbchan);
>  }
> +static DEVICE_ATTR_RO(nrbchan);
>  
> -static ssize_t _show_d_protocols(struct device *dev,
> -				 struct device_attribute *attr, char *buf)
> +static ssize_t d_protocols_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
>  {
>  	struct mISDNdevice *mdev = dev_to_mISDN(dev);
>  
> @@ -66,9 +68,10 @@ static ssize_t _show_d_protocols(struct device *dev,
>  		return -ENODEV;
>  	return sprintf(buf, "%d\n", mdev->Dprotocols);
>  }
> +static DEVICE_ATTR_RO(d_protocols);
>  
> -static ssize_t _show_b_protocols(struct device *dev,
> -				 struct device_attribute *attr, char *buf)
> +static ssize_t b_protocols_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
>  {
>  	struct mISDNdevice *mdev = dev_to_mISDN(dev);
>  
> @@ -76,9 +79,10 @@ static ssize_t _show_b_protocols(struct device *dev,
>  		return -ENODEV;
>  	return sprintf(buf, "%d\n", mdev->Bprotocols | get_all_Bprotocols());
>  }
> +static DEVICE_ATTR_RO(b_protocols);
>  
> -static ssize_t _show_protocol(struct device *dev,
> -			      struct device_attribute *attr, char *buf)
> +static ssize_t protocol_show(struct device *dev,
> +			     struct device_attribute *attr, char *buf)
>  {
>  	struct mISDNdevice *mdev = dev_to_mISDN(dev);
>  
> @@ -86,17 +90,19 @@ static ssize_t _show_protocol(struct device *dev,
>  		return -ENODEV;
>  	return sprintf(buf, "%d\n", mdev->D.protocol);
>  }
> +static DEVICE_ATTR_RO(protocol);
>  
> -static ssize_t _show_name(struct device *dev,
> -			  struct device_attribute *attr, char *buf)
> +static ssize_t name_show(struct device *dev,
> +			 struct device_attribute *attr, char *buf)
>  {
>  	strcpy(buf, dev_name(dev));
>  	return strlen(buf);
>  }
> +static DEVICE_ATTR_RO(name);
>  
>  #if 0 /* hangs */
> -static ssize_t _set_name(struct device *dev, struct device_attribute *attr,
> -			 const char *buf, size_t count)
> +static ssize_t name_set(struct device *dev, struct device_attribute *attr,
> +			const char *buf, size_t count)
>  {
>  	int err = 0;
>  	char *out = kmalloc(count + 1, GFP_KERNEL);
> @@ -113,10 +119,11 @@ static ssize_t _set_name(struct device *dev, struct device_attribute *attr,
>  
>  	return (err < 0) ? err : count;
>  }
> +static DEVICE_ATTR_RW(name);
>  #endif
>  
> -static ssize_t _show_channelmap(struct device *dev,
> -				struct device_attribute *attr, char *buf)
> +static ssize_t channelmap_show(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
>  {
>  	struct mISDNdevice *mdev = dev_to_mISDN(dev);
>  	char *bp = buf;
> @@ -127,18 +134,19 @@ static ssize_t _show_channelmap(struct device *dev,
>  
>  	return bp - buf;
>  }
> -
> -static struct device_attribute mISDN_dev_attrs[] = {
> -	__ATTR(id,          S_IRUGO,         _show_id,          NULL),
> -	__ATTR(d_protocols, S_IRUGO,         _show_d_protocols, NULL),
> -	__ATTR(b_protocols, S_IRUGO,         _show_b_protocols, NULL),
> -	__ATTR(protocol,    S_IRUGO,         _show_protocol,    NULL),
> -	__ATTR(channelmap,  S_IRUGO,         _show_channelmap,  NULL),
> -	__ATTR(nrbchan,     S_IRUGO,         _show_nrbchan,     NULL),
> -	__ATTR(name,        S_IRUGO,         _show_name,        NULL),
> -/*	__ATTR(name,        S_IRUGO | S_IWUSR, _show_name,      _set_name), */
> -	{}
> +static DEVICE_ATTR_RO(channelmap);
> +
> +static struct attribute *mISDN_attrs[] = {
> +	&dev_attr_id.attr,
> +	&dev_attr_d_protocols.attr,
> +	&dev_attr_b_protocols.attr,
> +	&dev_attr_protocol.attr,
> +	&dev_attr_channelmap.attr,
> +	&dev_attr_nrbchan.attr,
> +	&dev_attr_name.attr,
> +	NULL,
>  };
> +ATTRIBUTE_GROUPS(mISDN);
>  
>  static int mISDN_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
> @@ -162,7 +170,7 @@ static struct class mISDN_class = {
>  	.name = "mISDN",
>  	.owner = THIS_MODULE,
>  	.dev_uevent = mISDN_uevent,
> -	.dev_attrs = mISDN_dev_attrs,
> +	.dev_groups = mISDN_groups,
>  	.dev_release = mISDN_dev_release,
>  	.class_release = mISDN_class_release,
>  };
> 

