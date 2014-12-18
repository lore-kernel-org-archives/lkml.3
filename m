Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaLRARN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 19:17:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaLRARM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 19:17:12 -0500
Date: Wed, 17 Dec 2014 16:17:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Add device and vendor ID to
 vmbus devices
Message-ID: <20141218001711.GA6944@kroah.com>
References: <1418856744-16359-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418856744-16359-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 02:52:24PM -0800, K. Y. Srinivasan wrote:
> Add vendor and device ID attributes to vmbus devices. This would allow us to
> support vmbus based devices that can support guest RDMA.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/vmbus_drv.c |   20 ++++++++++++++++++++
>  include/linux/hyperv.h |    2 ++
>  2 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 4d6b269..215aac9 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -385,6 +385,24 @@ static ssize_t in_write_bytes_avail_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(in_write_bytes_avail);
>  
> +static ssize_t vendor_show(struct device *dev,
> +			   struct device_attribute *dev_atttr,
> +			   char *buf)
> +{
> +	struct hv_device *hv_dev = device_to_hv_device(dev);
> +	return sprintf(buf, "0x%x\n", hv_dev->vendor_id);
> +}
> +static DEVICE_ATTR_RO(vendor);
> +
> +static ssize_t device_show(struct device *dev,
> +			   struct device_attribute *dev_atttr,
> +			   char *buf)
> +{
> +	struct hv_device *hv_dev = device_to_hv_device(dev);
> +	return sprintf(buf, "0x%x\n", hv_dev->device_id);
> +}
> +static DEVICE_ATTR_RO(device);
> +
>  /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
>  static struct attribute *vmbus_attrs[] = {
>  	&dev_attr_id.attr,
> @@ -409,6 +427,8 @@ static struct attribute *vmbus_attrs[] = {
>  	&dev_attr_in_write_index.attr,
>  	&dev_attr_in_read_bytes_avail.attr,
>  	&dev_attr_in_write_bytes_avail.attr,
> +	&dev_attr_vendor.attr,
> +	&dev_attr_device.attr,
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(vmbus);
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 476c685..6fe4dfe 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -891,6 +891,8 @@ struct hv_device {
>  
>  	/* the device instance id of this device */
>  	uuid_le dev_instance;
> +	u16 vendor_id;
> +	u16 device_id;
>  
>  	struct device device;
>  

You are adding new sysfs files without proper Documentation/ABI/ updates
as well?  You know better than that...

And I don't see anything setting these fields, seems kind of pointless
as-is, right?

greg k-h
