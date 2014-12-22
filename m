Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaLVCAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:00:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaLVCAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:00:40 -0500
Date: Sun, 21 Dec 2014 18:00:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Simone Weiss <simone.weiss@fau.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        helene.gsaenger@studium.fau.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] dgnc/dgnc_sysfs.c: checkpatch: Use of pr_err insted
 of printk
Message-ID: <20141222020039.GA2489@kroah.com>
References: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
 <1419211054-3052-3-git-send-email-simone.weiss@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419211054-3052-3-git-send-email-simone.weiss@fau.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 02:17:30AM +0100, Simone Weiss wrote:
> 
> Signed-off-by: Simone Weiss <simone.weiss@fau.de>
> Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
> ---
>  drivers/staging/dgnc/dgnc_sysfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/dgnc/dgnc_sysfs.c b/drivers/staging/dgnc/dgnc_sysfs.c
> index 2fd34ca..0fa2388 100644
> --- a/drivers/staging/dgnc/dgnc_sysfs.c
> +++ b/drivers/staging/dgnc/dgnc_sysfs.c
> @@ -91,7 +91,7 @@ void dgnc_create_driver_sysfiles(struct pci_driver *dgnc_driver)
>  	rc |= driver_create_file(driverfs, &driver_attr_maxboards);
>  	rc |= driver_create_file(driverfs, &driver_attr_pollrate);
>  	if (rc)
> -		printk(KERN_ERR "DGNC: sysfs driver_create_file failed!\n");
> +		pr_err("DGNC: sysfs driver_create_file failed!\n");

No, use dev_err(), as you have access to a struct device.

thanks,

greg k-h
