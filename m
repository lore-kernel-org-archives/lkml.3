Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaBERVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:21:18 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:37341 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaBERVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:21:16 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+b24Ki3ZmbJ1FovkNviEleu1uvQb/HNWw=
X-DKIM: OpenDKIM Filter v2.0.1 titan ADA7B51E688
Date: Wed, 5 Feb 2014 12:21:07 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregory.clement@free-electrons.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH] mvebu : pcie: dt: potential issue in range parsing
Message-ID: <20140205172107.GU8533@titan.lakedaemon.net>
References: <1389349431-7997-1-git-send-email-jjhiblot@traphandler.com>
 <20140205164710.082f689e@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205164710.082f689e@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


+ Bjorn, linux-pci

Bjorn,

It looks like this didn't get Cc'd to linux-pci.  Here's a link:

  http://www.spinics.net/lists/arm-kernel/msg299721.html

On Wed, Feb 05, 2014 at 04:47:10PM +0100, Thomas Petazzoni wrote:
> Dear Jean-Jacques Hiblot,
> 
> On Fri, 10 Jan 2014 11:23:51 +0100, Jean-Jacques Hiblot wrote:
> > The second parameter of of_read_number is not the index, but a size.
> > As it happens, in this case it may work just fine because of the the conversion
> > to u32 and the favorable endianness on this architecture.
> > 
> > Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> > ---
> >  drivers/pci/host/pci-mvebu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
> > index c269e43..877e8ce 100644
> > --- a/drivers/pci/host/pci-mvebu.c
> > +++ b/drivers/pci/host/pci-mvebu.c
> > @@ -768,7 +768,7 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
> >  
> >  	for (i = 0; i < nranges; i++) {
> >  		u32 flags = of_read_number(range, 1);
> > -		u32 slot = of_read_number(range, 2);
> > +		u32 slot = of_read_number(range + 1, 1);
> >  		u64 cpuaddr = of_read_number(range + na, pna);
> >  		unsigned long rtype;
> >  
> 
> Sorry for the long delay, and thanks for the fix!
> 
> Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 
> (on Armada 370, with PCIe cards plugged in)


Fixes: 11be65472a427 ("PCI: mvebu: Adapt to the new device tree layout")
Cc: <stable@vger.kernel.org> # v3.12+
Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
