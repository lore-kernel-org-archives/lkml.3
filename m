Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab3J2Eyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 00:54:53 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:12350
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076Ab3J2Eyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 00:54:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I936eI542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
Message-ID: <1383022483.3410.85.camel@snotra.buserror.net>
Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
 sysfs only
From: Scott Wood <scottwood@freescale.com>
To: Bhushan Bharat-R65777 <R65777@freescale.com>
CC: Wood Scott-B07421 <B07421@freescale.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Mon, 28 Oct 2013 23:54:43 -0500
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D071D4FE5@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1381418830.7979.405.camel@snotra.buserror.net>
	 <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
	 <1381472840-3470-3-git-send-email-kim.phillips@linaro.org>
	 <1382982462.4097.38.camel@ul30vt.home>
	 <1382983205.3410.6.camel@snotra.buserror.net>
	 <1382983792.3410.13.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D071D4F0B@039-SN2MPN1-013.039d.mgd.msft.net>
	 <1383018042.3410.69.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D071D4F3A@039-SN2MPN1-013.039d.mgd.msft.net>
	 <1383020990.3410.76.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D071D4FA0@039-SN2MPN1-013.039d.mgd.msft.net>
	 <1383021306.3410.80.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D071D4FE5@039-SN2MPN1-013.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-28 at 23:45 -0500, Bhushan Bharat-R65777 wrote:
> 
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: Tuesday, October 29, 2013 10:05 AM
> > To: Bhushan Bharat-R65777
> > Cc: Wood Scott-B07421; Alex Williamson; Kim Phillips; Yoder Stuart-B08248;
> > christoffer.dall@linaro.org; linux-kernel@vger.kernel.org;
> > a.motakis@virtualopensystems.com; agraf@suse.de; Sethi Varun-B16395;
> > peter.maydell@linaro.org; santosh.shukla@linaro.org; kvm@vger.kernel.org;
> > gregkh@linuxfoundation.org
> > Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
> > sysfs only
> > 
> > On Mon, 2013-10-28 at 23:31 -0500, Bhushan Bharat-R65777 wrote:
> > >
> > > > -----Original Message-----
> > > > From: Wood Scott-B07421
> > > > Sent: Tuesday, October 29, 2013 10:00 AM
> > > > To: Bhushan Bharat-R65777
> > > > Cc: Wood Scott-B07421; Alex Williamson; Kim Phillips; Yoder
> > > > Stuart-B08248; christoffer.dall@linaro.org;
> > > > linux-kernel@vger.kernel.org; a.motakis@virtualopensystems.com;
> > > > agraf@suse.de; Sethi Varun-B16395; peter.maydell@linaro.org;
> > > > santosh.shukla@linaro.org; kvm@vger.kernel.org;
> > > > gregkh@linuxfoundation.org
> > > > Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit
> > > > binding via sysfs only
> > > >
> > > > On Mon, 2013-10-28 at 22:52 -0500, Bhushan Bharat-R65777 wrote:
> > > > > So when ids == NULL it does not check of vendor etc and calls
> > > > > pci_add_dynid()
> > > > which in turn calls driver_attach().
> > > > >
> > > > > If we change the above loop to break if ids->vendor == PCI_ANY_ID
> > > > >&& ids- subvendor == PCI_ANY_ID then also we will call pci_add_dyids().
> > > >
> > > > What problem are you trying to solve?
> > >
> > > new_id interface to continue working as before.
> > 
> > In what specific way does this allow new_id to continue working as before?  Be
> > verbose.
> 
> 
> What I observed that this patch (kim's patch) new_id interface stops working.

Yes.

>  This is found to be because store_new_id() checks for pdrv->id_table which is no more NULL, so the below check fails

I do not think that is the reason.  The reason is because
sysfs_bind_only is set, and this is not a direct sysfs bind.

>         if (ids) {
> ^^
> This is no more NULL, so enter inside the loop
> 
>                 retval = -EINVAL;
>                 while (ids->vendor || ids->subvendor || ids->class_mask) {
>                         if (driver_data == ids->driver_data) {
>                                 retval = 0;
>                                 break;
>                         }
>                         ids++;
>                 }
>                 if (retval)   /* No match */
>                         return retval;
> ^^^^^
> This is where it returns as -EINVAL

Why wouldn't it have broken out of the loop earlier, since driver_data
and ids->driver_data should both be zero?  I assume this is with a patch
to do PCI_ANY_ID in vfio-pci.

-Scott



