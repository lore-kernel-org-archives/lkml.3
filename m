Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3JKUnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:43:52 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:27951
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682Ab3JKUnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:43:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1381524220.7979.560.camel@snotra.buserror.net>
Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
 sysfs only
From: Scott Wood <scottwood@freescale.com>
To: Kim Phillips <kim.phillips@linaro.org>
CC: Bhushan Bharat <R65777@freescale.com>, Wood Scott <B07421@freescale.com>,
        Yoder Stuart <B08248@freescale.com>, <christoffer.dall@linaro.org>,
        <alex.williamson@redhat.com>, <linux-kernel@vger.kernel.org>,
        <a.motakis@virtualopensystems.com>, <agraf@suse.de>,
        Sethi Varun <B16395@freescale.com>, <peter.maydell@linaro.org>,
        <santosh.shukla@linaro.org>, <kvm@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Date: Fri, 11 Oct 2013 15:43:40 -0500
In-Reply-To: <1381472840-3470-3-git-send-email-kim.phillips@linaro.org>
References: <1381418830.7979.405.camel@snotra.buserror.net>
	 <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
	 <1381472840-3470-3-git-send-email-kim.phillips@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 01:27 -0500, Kim Phillips wrote:
> Force the vfio-pci driver to only be bound explicitly via sysfs to avoid
> conflics with other drivers in the event of a hotplug.
> 
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

You also need to add a PCI_ANY_ID match in order to be able to get rid
of the new_id usage.

-Scott



