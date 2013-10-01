Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab3JAWpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:45:08 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:43476
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092Ab3JAWpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:45:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1380667491.10618.67.camel@snotra.buserror.net>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Scott Wood <scottwood@freescale.com>
To: Kim Phillips <kim.phillips@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <a.motakis@virtualopensystems.com>, <agraf@suse.de>,
        <alex.williamson@redhat.com>, <stuart.yoder@freescale.com>,
        <B07421@freescale.com>, <B16395@freescale.com>, <R65777@freescale.com>,
        <peter.maydell@linaro.org>, <christoffer.dall@linaro.org>,
        <santosh.shukla@linaro.org>, <kvm@vger.kernel.org>
Date: Tue, 1 Oct 2013 17:44:51 -0500
In-Reply-To: <20131001165914.a7ebe64aac3e4bb0f845da29@linaro.org>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
	 <1380654938.10618.30.camel@snotra.buserror.net>
	 <20131001165914.a7ebe64aac3e4bb0f845da29@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 16:59 -0500, Kim Phillips wrote:
> On Tue, 1 Oct 2013 14:15:38 -0500
> Scott Wood <scottwood@freescale.com> wrote:
> 
> > I think the ideal interface would be if you could write the sysfs device
> > name into the vfio bind file (or some new file in the same directory),
> > and have it claim that device (preferably with an atomic unbind from the
> > previous driver).
> 
> ok.

...which apparently is what you are already doing (except for the atomic
part).  My recollection of how this works on PCI (via new_id) apparently
kept me from reading it properly. :-P

> > We shouldn't be messing around with compatible
> > (either modifying it or telling VFIO which compatibles to look for) when
> > we know the specific devices (not just type of devices) we want to bind.
> 
> ok, but I still don't see how to get past driver_match_device()'s
> refusal to allow bind a non-compatible driver (or one who's name isn't
> in the compatible list).

Probably something similar to your hack, except use a flag or some other
neutral mechanism rather than a driver name.

The flag could be something like "I'll try to bind to any device on this
bus, but only if explicitly requested".

-Scott



