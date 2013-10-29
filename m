Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3J2EfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 00:35:16 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:37263
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854Ab3J2EfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 00:35:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I936eI542I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
Message-ID: <1383021306.3410.80.camel@snotra.buserror.net>
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
Date: Mon, 28 Oct 2013 23:35:06 -0500
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D071D4FA0@039-SN2MPN1-013.039d.mgd.msft.net>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-28 at 23:31 -0500, Bhushan Bharat-R65777 wrote:
> 
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: Tuesday, October 29, 2013 10:00 AM
> > To: Bhushan Bharat-R65777
> > Cc: Wood Scott-B07421; Alex Williamson; Kim Phillips; Yoder Stuart-B08248;
> > christoffer.dall@linaro.org; linux-kernel@vger.kernel.org;
> > a.motakis@virtualopensystems.com; agraf@suse.de; Sethi Varun-B16395;
> > peter.maydell@linaro.org; santosh.shukla@linaro.org; kvm@vger.kernel.org;
> > gregkh@linuxfoundation.org
> > Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
> > sysfs only
> > 
> > On Mon, 2013-10-28 at 22:52 -0500, Bhushan Bharat-R65777 wrote:
> > >
> > > > -----Original Message-----
> > > > From: Wood Scott-B07421
> > > > Sent: Tuesday, October 29, 2013 9:11 AM
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
> > > > On Mon, 2013-10-28 at 22:38 -0500, Bhushan Bharat-R65777 wrote:
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Wood Scott-B07421
> > > > > > Sent: Monday, October 28, 2013 11:40 PM
> > > > > > To: Alex Williamson
> > > > > > Cc: Kim Phillips; Bhushan Bharat-R65777; Wood Scott-B07421;
> > > > > > Yoder Stuart-B08248; christoffer.dall@linaro.org;
> > > > > > linux-kernel@vger.kernel.org; a.motakis@virtualopensystems.com;
> > > > > > agraf@suse.de; Sethi Varun-B16395; peter.maydell@linaro.org;
> > > > > > santosh.shukla@linaro.org; kvm@vger.kernel.org;
> > > > > > gregkh@linuxfoundation.org
> > > > > > Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit
> > > > > > binding via sysfs only
> > > > > >
> > > > > > On Mon, 2013-10-28 at 13:00 -0500, Scott Wood wrote:
> > > > > > > On Mon, 2013-10-28 at 11:47 -0600, Alex Williamson wrote:
> > > > > > > > On Fri, 2013-10-11 at 01:27 -0500, Kim Phillips wrote:
> > > > > > > > > Force the vfio-pci driver to only be bound explicitly via
> > > > > > > > > sysfs to avoid conflics with other drivers in the event of a
> > hotplug.
> > > > > > > >
> > > > > > > > We can't break userspace, so we can't disable the current
> > > > > > > > method of binding devices to vfio-pci.  We can add a new
> > > > > > > > method and perhaps deprecate the existing mechanism to be
> > > > > > > > removed at some point in the future.  Thanks,
> > > > > > >
> > > > > > > I thought the existing method involved using sysfs bind, and
> > > > > > > this was just eliminating a race.  How does the bind get triggered
> > currently?
> > > > > >
> > > > > > OK, so it seems it's relying on the write to new_id calling
> > driver_attach().
> > > > > > Sigh.  I guess we could make driver-sysfs-bind-only be settable
> > > > > > via sysfs, and have new-userspace set both that and PCI_ANY_ID
> > > > > > (or the specific ID if userspace
> > > > > > prefers) via new_id.  The platform bus patches could continue as
> > > > > > is, since there's no existing mechanism to break.
> > > > >
> > > > > What about changing the store_new_id() to bypass exact ids check
> > > > > if driver
> > > > have PCI_ANY_ID?
> > > >
> > > > I don't follow.
> > >
> > > store_new_id() function id defined as:
> > >
> > > static ssize_t store_new_id(struct device_driver *driver, const char
> > > *buf, size_t count) {
> > >         struct pci_driver *pdrv = to_pci_driver(driver);
> > >         const struct pci_device_id *ids = pdrv->id_table;
> > >
> > > <snip>
> > >         /* Only accept driver_data values that match an existing id_table
> > >            entry */
> > >         if (ids) {
> > >                 retval = -EINVAL;
> > >                 while (ids->vendor || ids->subvendor || ids->class_mask) {
> > >                         if (driver_data == ids->driver_data) {
> > >                                 retval = 0;
> > >                                 break;
> > >                         }
> > >                         ids++;
> > >                 }
> > >                 if (retval)     /* No match */
> > >                         return retval;
> > >         }
> > >
> > >         retval = pci_add_dynid(pdrv, vendor, device, subvendor, subdevice,
> > >                                class, class_mask, driver_data); <snip>
> > >
> > >
> > > So when ids == NULL it does not check of vendor etc and calls pci_add_dynid()
> > which in turn calls driver_attach().
> > >
> > > If we change the above loop to break if ids->vendor == PCI_ANY_ID && ids-
> > >subvendor == PCI_ANY_ID then also we will call pci_add_dyids().
> > 
> > What problem are you trying to solve?
> 
> new_id interface to continue working as before.

In what specific way does this allow new_id to continue working as
before?  Be verbose.

-Scott



