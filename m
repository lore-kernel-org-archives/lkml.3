Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3JBSeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:34:19 -0400
Received: from [216.32.180.16] ([216.32.180.16]:37745 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754336Ab3JBSeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:34:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz98dI9371I936eI542I1432I168aJzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1380738758.12932.43.camel@snotra.buserror.net>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Scott Wood <scottwood@freescale.com>
To: Yoder Stuart-B08248 <B08248@freescale.com>
CC: Christoffer Dall <christoffer.dall@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kim Phillips <kim.phillips@linaro.org>,
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
Date: Wed, 2 Oct 2013 13:32:38 -0500
In-Reply-To: <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
	 <20131001200054.GA27330@kroah.com>
	 <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
	 <20131002015355.GD63102@lvm> <1380681356.14271.57.camel@ul30vt.home>
	 <20131002151413.GG63102@lvm>
	 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 13:25 -0500, Yoder Stuart-B08248 wrote:
> 
> > -----Original Message-----
> > From: Christoffer Dall [mailto:christoffer.dall@linaro.org]
> > Sent: Wednesday, October 02, 2013 10:14 AM
> > To: Alex Williamson
> > Cc: Kim Phillips; gregkh@linuxfoundation.org; linux-
> > kernel@vger.kernel.org; a.motakis@virtualopensystems.com; agraf@suse.de;
> > Yoder Stuart-B08248; Wood Scott-B07421; Sethi Varun-B16395; Bhushan
> > Bharat-R65777; peter.maydell@linaro.org; santosh.shukla@linaro.org;
> > kvm@vger.kernel.org
> > Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform
> > device
> > 
> > Wouldn't a sysfs file to add compatibility strings to the vfio-platform
> > driver make driver_match_device return true and make everyone happy?
> 
> I had a similar thought.  Why can't we do something like:
> 
>   echo "fsl,i2c" > /sys/bus/platform/drivers/vfio-platform/new_compatible
>   echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-platform/bind
> 
> The first steps tell vfio-platform to register itself to handle
> "fsl,i2c" compatible devices.  The second step does the bind.

Needing to specify the compatible is hacky (we already know what device
we want to bind; why do we need to scrounge up more information than
that, and add a new sysfs interface for extending compatible matches,
and a more flexible data structure to back that up?), and is racy on
buses that can hotplug (which driver gets the new device?).

What's wrong with a non-vfio-specific flag that a driver can set, that
indicates that the driver is willing to try to bind to any device on the
bus if explicitly requested via the existing sysfs bind mechanism?

-Scott



