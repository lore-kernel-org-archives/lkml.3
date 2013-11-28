Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab3K1GY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:24:29 -0500
Received: from smtprelay0173.hostedemail.com ([216.40.44.173]:41584 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750923Ab3K1GY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:24:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:45:355:379:541:599:857:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2551:2553:2559:2562:2731:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4605:5007:6119:6121:7652:7903:8604:9038:9108:9393:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12050:12114:12295:12296:12438:12517:12519:12663:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mind24_7dd682541b119
X-Filterd-Recvd-Size: 4127
Message-ID: <1385619863.12210.14.camel@joe-AO722>
Subject: Re: [PATCH 1/5] serial: 8250_pci: use DEFINE_PCI_DEVICE_TABLE macro
From: Joe Perches <joe@perches.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org
Date: Wed, 27 Nov 2013 22:24:23 -0800
In-Reply-To: <20131128055328.GA565@kroah.com>
References: <000601ceebdc$ee148de0$ca3da9a0$%han@samsung.com>
	 <20131128040750.GA29917@kroah.com>
	 <006001ceebfa$c85a1020$590e3060$%han@samsung.com>
	 <1385617213.12210.5.camel@joe-AO722> <20131128055328.GA565@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-27 at 21:53 -0800, 'Greg Kroah-Hartman' wrote:
> On Wed, Nov 27, 2013 at 09:40:13PM -0800, Joe Perches wrote:
> > On Thu, 2013-11-28 at 14:29 +0900, Jingoo Han wrote:
> > > On Thursday, November 28, 2013 1:08 PM, Greg Kroah-Hartman wrote:
> > > > On Thu, Nov 28, 2013 at 10:55:35AM +0900, Jingoo Han wrote:
> > > > > This macro is used to create a struct pci_device_id array.
> > > > 
> > > > Yeah, and it's a horrid macro that deserves to be removed, please don't
> > > > use it in more places.
> > > > 
> > > > Actually, if you could just remove it, that would be best, sorry, I'm
> > > > not going to take these patches.
> > > 
> > > (+cc Joe Perches, Andrew Morton, Andy Whitcroft)
> > > 
> > > Hi Joe Perches,
> > > 
> > > Would you fix checkpatch.pl about DEFINE_PCI_DEVICE_TABLE?
> > > Currently, checkpatch.pl guides to use DEFINE_PCI_DEVICE_TABLE
> > > as below.
> > > 
> > >   WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
> > >   #331: FILE: drivers/usb/host/ehci-pci.c:331:
> > >   +static const struct pci_device_id pci_ids [] = { {
> > > 
> > > However, Greg Kroah-Hartman mentioned that DEFINE_PCI_DEVICE_TABLE
> > > shouldn't be used anymore.
> > > 
> > > So, would you change checkpatch.pl in order to guide to use
> > > struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE?
> > > 
> > > For example,
> > >   WARNING: Use struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE
> > 
> > The documentation doesn't agree with Greg.
[]
> I say just remove it, I should have done that years ago when I was the
> PCI maintainer, just never got around to it.  No other bus has something
> like this for their device ids, why should PCI be "special"?

Anyone else have an opinion?

I don't care one way or another, but please, one way
not two.

Changing checkpatch is a trifle, but there are a _lot_
of maintainers to work through if it's to be removed.

It'll probably take several releases.

$ git grep --name-only -w DEFINE_PCI_DEVICE_TABLE | \
  cut -f1,2 -d/ | uniq -c
      1 Documentation/PCI
      1 arch/x86
      1 drivers/bcma
      3 drivers/block
      1 drivers/char
      1 drivers/cpufreq
      2 drivers/dma
     18 drivers/edac
      6 drivers/gpio
      6 drivers/gpu
      6 drivers/hwmon
     20 drivers/i2c
      2 drivers/infiniband
      1 drivers/ipack
      1 drivers/leds
      3 drivers/media
     10 drivers/mfd
      2 drivers/misc
      1 drivers/mmc
      1 drivers/mtd
    132 drivers/net
      1 drivers/ntb
      1 drivers/pci
      5 drivers/pcmcia
      2 drivers/platform
      1 drivers/ptp
      1 drivers/rapidio
      7 drivers/scsi
      3 drivers/spi
     65 drivers/staging
      3 drivers/tty
      1 drivers/uio
      5 drivers/usb
      1 drivers/video
      1 drivers/virtio
      3 drivers/vme
      9 drivers/watchdog
      1 drivers/xen
      1 include/linux
      1 scripts/checkpatch.pl
      1 scripts/tags.sh
      1 sound/oss
     67 sound/pci


