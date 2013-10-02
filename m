Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3JBSZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:25:30 -0400
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:36953
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271Ab3JBSZX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:25:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I936eI542I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Christoffer Dall <christoffer.dall@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC: Kim Phillips <kim.phillips@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: RFC: (re-)binding the VFIO platform driver to a platform device
Thread-Topic: RFC: (re-)binding the VFIO platform driver to a platform device
Thread-Index: AQHOvtVyiXjaos/F7ECAilSa5Xx4A5ngRDQAgAAiCgCAAECXgIAAC74AgADT3ICAADSaMA==
Date: Wed, 2 Oct 2013 18:25:18 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
 <20131001200054.GA27330@kroah.com>
 <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
 <20131002015355.GD63102@lvm> <1380681356.14271.57.camel@ul30vt.home>
 <20131002151413.GG63102@lvm>
In-Reply-To: <20131002151413.GG63102@lvm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.82.120.48]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoffer Dall [mailto:christoffer.dall@linaro.org]
> Sent: Wednesday, October 02, 2013 10:14 AM
> To: Alex Williamson
> Cc: Kim Phillips; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; a.motakis@virtualopensystems.com; agraf@suse.de;
> Yoder Stuart-B08248; Wood Scott-B07421; Sethi Varun-B16395; Bhushan
> Bharat-R65777; peter.maydell@linaro.org; santosh.shukla@linaro.org;
> kvm@vger.kernel.org
> Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform
> device
> 
> On Tue, Oct 01, 2013 at 08:35:56PM -0600, Alex Williamson wrote:
> > On Wed, 2013-10-02 at 02:53 +0100, Christoffer Dall wrote:
> > > On Tue, Oct 01, 2013 at 05:02:44PM -0500, Kim Phillips wrote:
> > > > On Tue, 1 Oct 2013 13:00:54 -0700
> > > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > > On Tue, Oct 01, 2013 at 01:38:31PM -0500, Kim Phillips wrote:
> > > > > > Hi,
> > > > > >
> > > > > > Santosh and I are having a problem figuring out how to enable
> binding
> > > > > > (and re-binding) platform devices to a platform VFIO driver
> (see
> > > > > > Antonis' WIP: [1]) in an upstream-acceptable manner.
> > > > > >
> > > > > > Binding platform drivers currently depends on a string match in
> the
> > > > > > device node's compatible entry.  On an arndale, one can
> currently
> > > > > > rebind the same device to the same driver like so:
> > > > > >
> > > > > > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-
> i2c/12ce0000.i2c/driver/unbind
> > > > > > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/bind
> > > > > >
> > > > > > And one can bind it to the vfio-dt driver, as Antonis
> instructs, by
> > > > > > appending a 'vfio-dt' string to the device tree compatible
> entry for
> > > > > > the device.  Then this would work:
> > > > > >
> > > > > > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-
> i2c/12ce0000.i2c/driver/unbind
> > > > > > echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-dt/bind
> > > > > >
> > > > > > Consequently, the hack patch below [2] allows any platform
> device to be
> > > > > > bound to the vfio-dt driver, without making changes to the
> device
> > > > > > tree.  It's a hack because I don't see having any driver name
> specific
> > > > > > code in drivers/base/bus.c being upstream acceptable.
> > > > >
> > > > > You are correct.
> > > > >
> > > > > What is wrong with just doing the above unbind/bind things
> through
> > > > > sysfs, that is what it is there for, right?
> > > >
> > > > The bind fails because the compatible string in the device tree
> doesn't
> > > > match that of the VFIO platform driver, so driver_match_device
> always
> > > > returns false.
> > > >
> > > It sounds like this is not going to be pretty almost no matter what
> > > we'll end up doing: Inherently VFIO is going to bind to a device
> without
> > > the device tree entry for that device ever saying anything about
> VFIO.
> > >
> > > How is this solved for PCI?  Can we use some analogy from that work
> to
> > > construct the missing piece?
> >
> > PCI supports a dynamic ID table for driver/device matching, see
> > pci_add_dynid().  The problem is that this gets a little sloppy for the
> > period where you have multiple drivers that can claim the same device,
> > especially in the presence of hotplug.  Thus the desire to improve the
> > situation with some kind of direct binding interface.  Thanks,
> >
> So that's called on the vfio pci driver?
> 
> Wouldn't a sysfs file to add compatibility strings to the vfio-platform
> driver make driver_match_device return true and make everyone happy?

I had a similar thought.  Why can't we do something like:

  echo "fsl,i2c" > /sys/bus/platform/drivers/vfio-platform/new_compatible
  echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-platform/bind

The first steps tell vfio-platform to register itself to handle
"fsl,i2c" compatible devices.  The second step does the bind.

Stuart

