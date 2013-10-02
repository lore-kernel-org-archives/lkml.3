Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab3JBVIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:08:50 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:5663
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754165Ab3JBVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:08:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1380748121.12932.89.camel@snotra.buserror.net>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Scott Wood <scottwood@freescale.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Christoffer Dall <christoffer.dall@linaro.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Wed, 2 Oct 2013 16:08:41 -0500
In-Reply-To: <20131002203735.GA10871@kroah.com>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
	 <20131001200054.GA27330@kroah.com>
	 <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
	 <20131002015355.GD63102@lvm> <1380681356.14271.57.camel@ul30vt.home>
	 <20131002151413.GG63102@lvm>
	 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
	 <1380738758.12932.43.camel@snotra.buserror.net>
	 <20131002184330.GC5108@cbox> <20131002203735.GA10871@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 13:37 -0700, gregkh@linuxfoundation.org wrote:
> On Wed, Oct 02, 2013 at 11:43:30AM -0700, Christoffer Dall wrote:
> > > What's wrong with a non-vfio-specific flag that a driver can set, that
> > > indicates that the driver is willing to try to bind to any device on the
> > > bus if explicitly requested via the existing sysfs bind mechanism?
> > > 
> > It sounds more hackish to me to invent some 'generic' flag to solve a
> > very specific case.  What you're suggesting would let users specify that
> > a serial driver should handle a NIC hardware, no?  That sounds much much
> > worse to me.
> 
> You can do that today, with any PCI driver (or USB driver as well), just
> use the bind/unbind files in sysfs and you had better "know" what you
> are doing...

sysfs bind won't work if it driver_match_device() fails.  PCI has
PCI_ANY_ID, so the missing piece for PCI is a way to say that the driver
should not bind to a device except when explicitly requested via sysfs
bind.

I don't see any equivalent functionality to PCI_ANY_ID for platform
devices.

-Scott



