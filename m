Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3JATRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:17:43 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:36852
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360Ab3JATRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:17:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1380655036.10618.32.camel@snotra.buserror.net>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Scott Wood <scottwood@freescale.com>
To: Kim Phillips <kim.phillips@linaro.org>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <a.motakis@virtualopensystems.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        <stuart.yoder@freescale.com>, Wood Scott-B07421 <B07421@freescale.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        <santosh.shukla@linaro.org>, <kvm@vger.kernel.org>
Date: Tue, 1 Oct 2013 14:17:16 -0500
In-Reply-To: <1380654938.10618.30.camel@snotra.buserror.net>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
	 <1380654938.10618.30.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 14:15 -0500, Scott Wood wrote:
> On Tue, 2013-10-01 at 13:38 -0500, Kim Phillips wrote:
> > Hi,
> > 
> > Santosh and I are having a problem figuring out how to enable binding
> > (and re-binding) platform devices to a platform VFIO driver (see
> > Antonis' WIP: [1]) in an upstream-acceptable manner.
> > 
> > Binding platform drivers currently depends on a string match in the
> > device node's compatible entry.  On an arndale, one can currently
> > rebind the same device to the same driver like so:
> > 
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/bind
> > 
> > And one can bind it to the vfio-dt driver, as Antonis instructs, by
> > appending a 'vfio-dt' string to the device tree compatible entry for
> > the device.  Then this would work:
> > 
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-dt/bind
> > 
> > Consequently, the hack patch below [2] allows any platform device to be
> > bound to the vfio-dt driver, without making changes to the device
> > tree.  It's a hack because I don't see having any driver name specific
> > code in drivers/base/bus.c being upstream acceptable.
> 
> Modifying the device tree is the worse part of this.

I think I missed something.  How do you reconcile "without making
changes to the device tree" with "appending a 'vfio-dt' string to the
device tree compatible entry"?

-Scott



