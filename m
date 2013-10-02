Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3JBUTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:19:54 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:33369
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706Ab3JBUTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:19:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1380745177.12932.81.camel@snotra.buserror.net>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Scott Wood <scottwood@freescale.com>
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: Kim Phillips <kim.phillips@linaro.org>, <B08248@freescale.com>,
        <alex.williamson@redhat.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <a.motakis@virtualopensystems.com>,
        <agraf@suse.de>, <B07421@freescale.com>, <B16395@freescale.com>,
        <R65777@freescale.com>, <peter.maydell@linaro.org>,
        <santosh.shukla@linaro.org>, <kvm@vger.kernel.org>
Date: Wed, 2 Oct 2013 15:19:37 -0500
In-Reply-To: <20131002201307.GA3029@lvm>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
	 <20131001200054.GA27330@kroah.com>
	 <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
	 <20131002015355.GD63102@lvm> <1380681356.14271.57.camel@ul30vt.home>
	 <20131002151413.GG63102@lvm>
	 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
	 <1380738758.12932.43.camel@snotra.buserror.net>
	 <20131002184330.GC5108@cbox>
	 <20131002150415.458f40ac97cd6ea9de9c590d@linaro.org>
	 <20131002201307.GA3029@lvm>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 21:13 +0100, Christoffer Dall wrote:
> On Wed, Oct 02, 2013 at 03:04:15PM -0500, Kim Phillips wrote:
> > On Wed, 2 Oct 2013 11:43:30 -0700
> > Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > 
> > > On Wed, Oct 02, 2013 at 01:32:38PM -0500, Scott Wood wrote:
> > > > What's wrong with a non-vfio-specific flag that a driver can set, that
> > > > indicates that the driver is willing to try to bind to any device on the
> > > > bus if explicitly requested via the existing sysfs bind mechanism?
> > > > 
> > > It sounds more hackish to me to invent some 'generic' flag to solve a
> > > very specific case.  What you're suggesting would let users specify that
> > > a serial driver should handle a NIC hardware, no?  That sounds much much
> > > worse to me.
> > 
> > I thought that was the nature of VFIO drivers...it's a 'meta-' driver,
> > used for enabling userspace drivers at large.
> > 
> Yes, vfio is a meta driver, therefore it needs to be able to do
> something special, but the generic driver/device/bus matching framework
> doesn't need an extra generic feature allowing you to bind driver X to
> device Y for all combinations of X and Y depending on  some flag...

Not all combinations of X and Y.  Only instances of X that advertise
that this is OK.

> Someone please correct me if there are more use cases for this and this
> is in fact worth a generic solution.

Note that the wildcard match that I suggested in the e-mail I just sent
would likely be implemented by the bus match code -- not by generic
driver model code.  It would still be less intrusive than implementing a
dynamic match mechanism for each bus type (and for device tree, ACPI,
etc in the case of platform bus).

-Scott



