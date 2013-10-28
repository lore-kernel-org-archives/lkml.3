Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3J1Rry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:47:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806Ab3J1Rrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:47:53 -0400
Message-ID: <1382982462.4097.38.camel@ul30vt.home>
Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
 sysfs only
From: Alex Williamson <alex.williamson@redhat.com>
To: Kim Phillips <kim.phillips@linaro.org>
Cc: Bhushan Bharat <R65777@freescale.com>, Wood Scott <B07421@freescale.com>,
        Yoder Stuart <B08248@freescale.com>, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, a.motakis@virtualopensystems.com,
        agraf@suse.de, Sethi Varun <B16395@freescale.com>,
        peter.maydell@linaro.org, santosh.shukla@linaro.org,
        kvm@vger.kernel.org, gregkh@linuxfoundation.org
Date: Mon, 28 Oct 2013 11:47:42 -0600
In-Reply-To: <1381472840-3470-3-git-send-email-kim.phillips@linaro.org>
References: <1381418830.7979.405.camel@snotra.buserror.net>
	 <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
	 <1381472840-3470-3-git-send-email-kim.phillips@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 01:27 -0500, Kim Phillips wrote:
> Force the vfio-pci driver to only be bound explicitly via sysfs to avoid
> conflics with other drivers in the event of a hotplug.

We can't break userspace, so we can't disable the current method of
binding devices to vfio-pci.  We can add a new method and perhaps
deprecate the existing mechanism to be removed at some point in the
future.  Thanks,

Alex

> Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
> ---
>  drivers/vfio/pci/vfio_pci.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 6ab71b9..bdd7833 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -901,6 +901,9 @@ static struct pci_driver vfio_pci_driver = {
>  	.probe		= vfio_pci_probe,
>  	.remove		= vfio_pci_remove,
>  	.err_handler	= &vfio_err_handlers,
> +	.driver = {
> +		.sysfs_bind_only = true,
> +	},
>  };
>  
>  static void __exit vfio_pci_cleanup(void)



