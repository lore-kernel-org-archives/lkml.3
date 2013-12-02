Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3LBFsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:48:24 -0500
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:49651 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751024Ab3LBFsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:48:19 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:45:355:379:541:599:968:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:1981:2194:2198:2199:2200:2393:2551:2553:2559:2562:2693:2731:2828:3138:3139:3140:3141:3142:3421:3865:3866:3867:3868:3870:3871:3872:3873:3874:4117:4250:4321:4605:5007:6119:7652:7875:7903:8604:9010:9036:9108:9393:10004:10848:11026:11232:11473:11658:11914:12043:12050:12114:12295:12296:12438:12517:12519:12663:12740:13019,0,RBL:none,CacheIP:none,Bayesian:0.5
X-HE-Tag: alarm86_2b2cadb163b3f
X-Filterd-Recvd-Size: 6329
Message-ID: <1385963295.2680.2.camel@joe-AO722>
Subject: Re: [PATCH 1/5] serial: 8250_pci: use DEFINE_PCI_DEVICE_TABLE macro
From: Joe Perches <joe@perches.com>
To: Jingoo Han <jg1.han@samsung.com>, Jonas Bonn <jonas@southpole.se>
Cc: "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org
Date: Sun, 01 Dec 2013 21:48:15 -0800
In-Reply-To: <001001ceef13$7fa3ee70$7eebcb50$%han@samsung.com>
References: <000601ceebdc$ee148de0$ca3da9a0$%han@samsung.com>
	 <20131128040750.GA29917@kroah.com>
	 <006001ceebfa$c85a1020$590e3060$%han@samsung.com>
	 <1385617213.12210.5.camel@joe-AO722> <20131128055328.GA565@kroah.com>
	 <1385619863.12210.14.camel@joe-AO722> <529C026E.2000302@roeck-us.net>
	 <000f01ceef11$a14acf00$e3e06d00$%han@samsung.com>
	 <529C04C7.9050506@roeck-us.net>
	 <001001ceef13$7fa3ee70$7eebcb50$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Jonas Bonn to list as he added the macro in the first place...)

On Mon, 2013-12-02 at 13:03 +0900, Jingoo Han wrote:
> On Monday, December 02, 2013 12:56 PM, Guenter Roeck wrote:
> > On 12/01/2013 07:50 PM, Jingoo Han wrote:
> > > On Monday, December 02, 2013 12:46 PM, Guenter Roeck wrote:
> > >> On 12/01/2013 04:07 PM, Jingoo Han wrote:
> > >>> On Friday, November 29, 2013 10:34 AM, Jingoo Han wrote:
> > >>>> On Thursday, November 28, 2013 3:24 PM, Joe Perches wrote:
> > >>>>> On Wed, 2013-11-27 at 21:53 -0800, 'Greg Kroah-Hartman' wrote:
> > >>>>>> On Wed, Nov 27, 2013 at 09:40:13PM -0800, Joe Perches wrote:
> > >>>>>>> On Thu, 2013-11-28 at 14:29 +0900, Jingoo Han wrote:
> > >>>>>>>> On Thursday, November 28, 2013 1:08 PM, Greg Kroah-Hartman wrote:
> > >>>>>>>>> On Thu, Nov 28, 2013 at 10:55:35AM +0900, Jingoo Han wrote:
> > >>>>>>>>>> This macro is used to create a struct pci_device_id array.
> > >>>>>>>>>
> > >>>>>>>>> Yeah, and it's a horrid macro that deserves to be removed, please don't
> > >>>>>>>>> use it in more places.
> > >>>>>>>>>
> > >>>>>>>>> Actually, if you could just remove it, that would be best, sorry, I'm
> > >>>>>>>>> not going to take these patches.
> > >>>>>>>>
> > >>>>>>>> (+cc Joe Perches, Andrew Morton, Andy Whitcroft)
> > >>>>>>>>
> > >>>>>>>> Hi Joe Perches,
> > >>>>>>>>
> > >>>>>>>> Would you fix checkpatch.pl about DEFINE_PCI_DEVICE_TABLE?
> > >>>>>>>> Currently, checkpatch.pl guides to use DEFINE_PCI_DEVICE_TABLE
> > >>>>>>>> as below.
> > >>>>>>>>
> > >>>>>>>>     WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
> > >>>>>>>>     #331: FILE: drivers/usb/host/ehci-pci.c:331:
> > >>>>>>>>     +static const struct pci_device_id pci_ids [] = { {
> > >>>>>>>>
> > >>>>>>>> However, Greg Kroah-Hartman mentioned that DEFINE_PCI_DEVICE_TABLE
> > >>>>>>>> shouldn't be used anymore.
> > >>>>>>>>
> > >>>>>>>> So, would you change checkpatch.pl in order to guide to use
> > >>>>>>>> struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE?
> > >>>>>>>>
> > >>>>>>>> For example,
> > >>>>>>>>     WARNING: Use struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE
> > >>>>>>>
> > >>>>>>> The documentation doesn't agree with Greg.
> > >>>>> []
> > >>>>>> I say just remove it, I should have done that years ago when I was the
> > >>>>>> PCI maintainer, just never got around to it.  No other bus has something
> > >>>>>> like this for their device ids, why should PCI be "special"?
> > >>>>>
> > >>>>> Anyone else have an opinion?
> > >>>>>
> > >>>>> I don't care one way or another, but please, one way
> > >>>>> not two.
> > >>>>
> > >>
> > >> Same here.
> > >>
> > >>>> (+cc Bjorn Helgaas, linux-pci)
> > >>>>
> > >>>> Then, how about the following steps?
> > >>>>
> > >>>> 1. Fix ./Documentation/PCI/pci.txt as below.
> > >>>>      (Jingoo Han)
> > >>>>      The ID table is an array of struct pci_device_id entries ending with an
> > >>>>      -all-zero entry; use of the macro DEFINE_PCI_DEVICE_TABLE is the preferred
> > >>>>      -method of declaring the table.  Each entry consists of:
> > >>>>      +all-zero entry; Each entry consists of:
> > >>>>
> > >>>> 2. Fix ./scripts/checkpatch.pl in order to guide to use
> > >>>>       struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE.
> > >>>>       (Joe Perches)
> > >>>
> > >>> If all DEFINE_PCI_DEVICE_TABLEs are replaced with 'const struct pci_device_id'
> > >>> and these patches are merged through 'driver-core.git', it will be not
> > >>> necessary to fix ./scripts/checkpatch.pl.
> > >>>
> > >> Why not ?
> > >
> > > I will replace all DEFINE_PCI_DEVICE_TABLEs with 'const struct pci_device_id',
> > > and remove the definition of DEFINE_PCI_DEVICE_TABLE macro.
> > >
> > > --- a/include/linux/pci.h
> > > +++ b/include/linux/pci.h
> > > @@ -631,16 +631,6 @@ struct pci_driver {
> > >   #define        to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
> > >
> > >   /**
> > > - * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
> > > - * @_table: device table name
> > > - *
> > > - * This macro is used to create a struct pci_device_id array (a device table)
> > > - * in a generic manner.
> > > - */
> > > -#define DEFINE_PCI_DEVICE_TABLE(_table) \
> > > -       const struct pci_device_id _table[]
> > > -
> > > -/**
> > >
> > > In this case, there is no DEFINE_PCI_DEVICE_TABLE usage
> > > in the kernel. If someone uses DEFINE_PCI_DEVICE_TABLE macro,
> > > it will make  build error.
> > >
> > 
> > And that will make the checkpatch warning go away ?
> > That seems to be very unlikely.
> 
> OK, I will ask Joe Perches to remove the following checkpatch
> warning.
> 
>     WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
> 
> Best regards,
> Jingoo Han
> 



