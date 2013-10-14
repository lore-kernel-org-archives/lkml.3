Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3JNNBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:01:16 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:5303
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755670Ab3JNNBO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:01:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I936eI542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Kim Phillips <kim.phillips@linaro.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC: Bhushan Bharat-R65777 <R65777@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
 sysfs only
Thread-Topic: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
 sysfs only
Thread-Index: AQHOxkr6bbFT8NuiMUCyYeg1D4NxlJnv+IwAgAAq64CABAqocA==
Date: Mon, 14 Oct 2013 13:01:11 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E15036E2CB8@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1381418830.7979.405.camel@snotra.buserror.net>
	<1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
	<1381472840-3470-3-git-send-email-kim.phillips@linaro.org>
	<1381524220.7979.560.camel@snotra.buserror.net>
 <20131011181717.e4051736cf42c5a647222941@linaro.org>
In-Reply-To: <20131011181717.e4051736cf42c5a647222941@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.81.30]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kim Phillips [mailto:kim.phillips@linaro.org]
> Sent: Friday, October 11, 2013 6:17 PM
> To: Wood Scott-B07421
> Cc: Bhushan Bharat-R65777; Wood Scott-B07421; Yoder Stuart-B08248;
> christoffer.dall@linaro.org; alex.williamson@redhat.com; linux-
> kernel@vger.kernel.org; a.motakis@virtualopensystems.com; agraf@suse.de;
> Sethi Varun-B16395; peter.maydell@linaro.org; santosh.shukla@linaro.org;
> kvm@vger.kernel.org; gregkh@linuxfoundation.org
> Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding
> via sysfs only
> 
> On Fri, 11 Oct 2013 15:43:40 -0500
> Scott Wood <scottwood@freescale.com> wrote:
> 
> > On Fri, 2013-10-11 at 01:27 -0500, Kim Phillips wrote:
> > > Force the vfio-pci driver to only be bound explicitly via sysfs to
> avoid
> > > conflics with other drivers in the event of a hotplug.
> > >
> > > Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
> > > ---
> > >  drivers/vfio/pci/vfio_pci.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci.c
> b/drivers/vfio/pci/vfio_pci.c
> > > index 6ab71b9..bdd7833 100644
> > > --- a/drivers/vfio/pci/vfio_pci.c
> > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > @@ -901,6 +901,9 @@ static struct pci_driver vfio_pci_driver = {
> > >  	.probe		= vfio_pci_probe,
> > >  	.remove		= vfio_pci_remove,
> > >  	.err_handler	= &vfio_err_handlers,
> > > +	.driver = {
> > > +		.sysfs_bind_only = true,
> > > +	},
> > >  };
> > >
> > >  static void __exit vfio_pci_cleanup(void)
> >
> > You also need to add a PCI_ANY_ID match in order to be able to get rid
> > of the new_id usage.
> 
> thanks - see below.
> 
> Can someone with a PCI bus test this?  Bharat?
> 
> Kim
> 
> From a8d6c12f2ec763c2ac7fd384a3397c370cc1b932 Mon Sep 17 00:00:00 2001
> From: Kim Phillips <kim.phillips@linaro.org>
> Date: Thu, 10 Oct 2013 22:16:34 -0500
> Subject: [PATCH 3/4 v2] VFIO: pci: amend vfio-pci for explicit binding
> via sysfs
>  only
> 
> Force the vfio-pci driver to only be bound explicitly via sysfs to avoid
> conflics with other drivers in the event of a hotplug.  Also replace
> the only dynamic ids assignment with a table with a single PCI_ANY_ID
> entry since writing the sysfs bind file without having to specify ids
> via the new_id file first should no longer be necessary.
> 
> Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
> ---
>  drivers/vfio/pci/vfio_pci.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 6ab71b9..c5b434f 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -895,12 +895,22 @@ static struct pci_error_handlers vfio_err_handlers
> = {
>  	.error_detected = vfio_pci_aer_err_detected,
>  };
> 
> +static DEFINE_PCI_DEVICE_TABLE(vfio_pci_id_table) = {
> +        { PCI_DEVICE(PCI_ANY_ID, PCI_ANY_ID) },
> +        { 0 }
> +};
> +
> +MODULE_DEVICE_TABLE(pci, vfio_pci_id_table);
> +
>  static struct pci_driver vfio_pci_driver = {
>  	.name		= "vfio-pci",
> -	.id_table	= NULL, /* only dynamic ids */
> +	.id_table	= vfio_pci_id_table, /* no dynamic ids */
>  	.probe		= vfio_pci_probe,
>  	.remove		= vfio_pci_remove,
>  	.err_handler	= &vfio_err_handlers,
> +	.driver = {
> +		.sysfs_bind_only = true, /* bind only via sysfs */
> +	},
>  };
> 
>  static void __exit vfio_pci_cleanup(void)

sysfs bind only seems orthogonal to PCI_ANY_ID...I would have split
those into 2 different patches.

Stuart

