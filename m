Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3FEPL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:11:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab3FEPLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:11:25 -0400
Message-ID: <1370445082.3516.15.camel@ul30vt.home>
Subject: Re: [PATCH] vfio: fix crash on rmmod
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Jun 2013 09:11:22 -0600
In-Reply-To: <1370412194-32211-1-git-send-email-aik@ozlabs.ru>
References: <1370412194-32211-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 16:03 +1000, Alexey Kardashevskiy wrote:
> devtmpfs_delete_node() calls devnode() callback with mode==NULL but
> vfio still tries to write there.
> 
> The patch fixes this.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> ---

Oops.  Applied.  The mode change just went in for 3.10, so I'll get this
in before the final rc.  Thanks,

Alex

> Steps to reproduce on freshly booted system with no devices given to VFIO:
> modprobe vfio
> rmmod vfio_iommu_spapr_tce
> rmmod vfio
> ---
>  drivers/vfio/vfio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 523c121..259ad28 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1360,7 +1360,7 @@ static const struct file_operations vfio_device_fops = {
>   */
>  static char *vfio_devnode(struct device *dev, umode_t *mode)
>  {
> -	if (MINOR(dev->devt) == 0)
> +	if (mode && (MINOR(dev->devt) == 0))
>  		*mode = S_IRUGO | S_IWUGO;
>  
>  	return kasprintf(GFP_KERNEL, "vfio/%s", dev_name(dev));



