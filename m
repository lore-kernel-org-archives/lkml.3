Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaI2GRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 02:17:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaI2GRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 02:17:15 -0400
Date: Sun, 28 Sep 2014 21:52:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>, monstr@monstr.eu,
        linux-usb@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/usb/host/ehci-xilinx-of.c: Include
 "linux/of_irq.h" to avoid compiling error
Message-ID: <20140929015224.GB27008@kroah.com>
References: <e0dec78e-193e-43ee-bdb0-fa776a6dd044@BY2FFO11FD030.protection.gbl>
 <Pine.LNX.4.44L0.1409241141260.1580-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409241141260.1580-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:41:55AM -0400, Alan Stern wrote:
> On Mon, 22 Sep 2014, Michal Simek wrote:
> 
> > Hi Alan and Greg,
> > 
> > On 09/20/2014 06:19 AM, Chen Gang wrote:
> > > Hello Maintainers:
> > > 
> > > Please help check this patch, when you have time.
> > > 
> > > Thanks.
> > > 
> > > On 09/08/2014 01:20 PM, Michal Simek wrote:
> > >> On 09/03/2014 05:50 PM, Chen Gang wrote:
> > >>> Need include it for irq_of_parse_and_map(), the related error with
> > >>> allmodconfig under microblaze:
> > >>>
> > >>>   drivers/usb/host/ehci-xilinx-of.c: In function ?ehci_hcd_xilinx_of_probe?:
> > >>>   drivers/usb/host/ehci-xilinx-of.c:156:2: error: implicit declaration of function ?irq_of_parse_and_map? [-Werror=implicit-function-declaration]
> > >>>     irq = irq_of_parse_and_map(dn, 0);
> > >>>     ^
> > >>>
> > >>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> > >>> ---
> > >>>  drivers/usb/host/ehci-xilinx-of.c | 1 +
> > >>>  1 file changed, 1 insertion(+)
> > >>>
> > >>> diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
> > >>> index fe57710..a232836 100644
> > >>> --- a/drivers/usb/host/ehci-xilinx-of.c
> > >>> +++ b/drivers/usb/host/ehci-xilinx-of.c
> > >>> @@ -31,6 +31,7 @@
> > >>>  #include <linux/of.h>
> > >>>  #include <linux/of_platform.h>
> > >>>  #include <linux/of_address.h>
> > >>> +#include <linux/of_irq.h>
> > >>>  
> > >>>  /**
> > >>>   * ehci_xilinx_port_handed_over - hand the port out if failed to enable it
> > >>>
> > >>
> > >> Acked-by: Michal Simek <monstr@monstr.eu>
> > 
> > Alan: Can you please add this patch to your queue?
> > Greg: If Alan is not maintaining this part of kernel, is this patch in your queue?
> > 
> > I have also not a problem to add this patch through my microblaze tree
> > but I think it will be much better to use any USB tree.
> 
> Greg should be able to accept a trivial patch like this one directly.

I can, if someone will resend it so I can apply it :)

thanks,

greg k-h
