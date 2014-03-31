Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaCaWcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:32:25 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:52810 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaCaWcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:32:23 -0400
Date: Mon, 31 Mar 2014 17:32:18 -0500
From: Kim Phillips <kim.phillips@linaro.org>
To: stuart.yoder@freescale.com
Cc: gregkh@linuxfoundation.org, kvm@vger.kernel.org, jan.kiszka@siemens.com,
        will.deacon@arm.com, mhocko@suse.cz, bhelgaas@google.com,
        Varun.Sethi@freescale.com, kvmarm@lists.cs.columbia.edu,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, d.kasatkin@samsung.com,
        tj@kernel.org, alex.williamson@redhat.com, scottwood@freescale.com,
        tech@virtualopensystems.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        joe@perches.com, kim.phillips@freescale.com
Subject: Re: mechanism to allow a driver to bind to any device
Message-Id: <20140331173218.d12bc3ca7773139a09822dfc@linaro.org>
In-Reply-To: <c6a10ce9bfd84287b5c5aa3809987b2b@DM2PR03MB352.namprd03.prod.outlook.com>
References: <7043e1edd9974de590dcb392cd8aff14@DM2PR03MB352.namprd03.prod.outlook.com>
	<20140215173348.GA8056@kroah.com>
	<b6374a0f30194969ba4622ff2f58ae65@DM2PR03MB352.namprd03.prod.outlook.com>
	<20140220224337.GA20097@kroah.com>
	<54cd150235ba4954becdd12f725c5ebd@DM2PR03MB352.namprd03.prod.outlook.com>
	<20140326144025.GA18387@phenom.dumpdata.com>
	<D45FC8F2-7807-4BBB-A253-8EFCD091D6BD@suse.de>
	<1395850862.632.247.camel@ul30vt.home>
	<1395871761.632.316.camel@ul30vt.home>
	<7d1b495cdb6a415e8d3b7f60f409991c@DM2PR03MB352.namprd03.prod.outlook.com>
	<20140331194705.GA13014@kroah.com>
	<c6a10ce9bfd84287b5c5aa3809987b2b@DM2PR03MB352.namprd03.prod.outlook.com>
X-Mailer: Sylpheed 3.4.0beta5 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 20:23:36 +0000
Stuart Yoder <stuart.yoder@freescale.com> wrote:

> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Monday, March 31, 2014 2:47 PM
> > 
> > On Mon, Mar 31, 2014 at 06:47:51PM +0000, Stuart Yoder wrote:
> > > I also, was at the point where I thought we should perhaps just
> > > go with current mechanisms and implement new_id for the platform
> > > bus...but Greg's recent response is 'platform devices suck' and it
> > sounds
> > > like he would reject a new_id patch for the platform bus.  So it kind
> > > of feels like we are stuck.
> > 
> > ids mean nothing in the platform device model, so having a new_id file
> > for them makes no sense.
> 
> They don't have IDs like PCI, but platform drivers have to match on
> something.  Platform device match tables are based on compatible strings.
> 
> Example from Freescale DMA driver:
>   static const struct of_device_id fsldma_of_ids[] = {
>         { .compatible = "fsl,elo3-dma", },
>         { .compatible = "fsl,eloplus-dma", },
>         { .compatible = "fsl,elo-dma", },
>         {}
>   };
> 
> The process of unbinding, setting a new_id, and binding to vfio would work
> just like PCI:
> 
>    echo ffe101300.dma > /sys/bus/platform/devices/ffe101300.dma/driver/unbind
>    echo fsl,eloplus-dma > /sys/bus/platform/drivers/vfio-platform/new_id

In platform device land, we don't want to pursue the
new_id/match-by-compatible methodology: we know exactly which specific
device (not device types) we want bound to which driver, so we just
want to be able to simply:

echo fff51000.ethernet | sudo tee -a /sys/bus/platform/devices/fff51000.ethernet/driver/unbind
echo fff51000.ethernet | sudo tee -a /sys/bus/platform/drivers/vfio-platform/bind

and not get involved with how PCI "doesn't simply do that," independent
of autoprobe/hotplug.

Kim
