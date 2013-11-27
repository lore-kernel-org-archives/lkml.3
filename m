Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab3K0TWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:22:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3K0TWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:22:05 -0500
Date: Wed, 27 Nov 2013 11:22:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH 5/6] GenWQE Sysfs interfaces
Message-ID: <20131127192204.GC28409@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
 <1383741943-14609-6-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383741943-14609-6-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 01:45:42PM +0100, Frank Haverkamp wrote:
> +/**
> + * genwqe_init_sysfs() - Setup sysfs entries of the card device
> + */
> +int genwqe_init_sysfs(struct genwqe_dev *cd)
> +{
> +	int rc;
> +
> +	rc = sysfs_create_group(&cd->dev->kobj, &genwqe_attribute_group);
> +	if (rc)
> +		return -ENXIO;
> +
> +	return 0;
> +}

Why isn't this group the "default" one for the device?  That way you
don't have to explicitly create/remove it, the driver core handles it
all automatically for you, and you don't race with userspace when it is
created/announced.

thanks,

greg k-h
