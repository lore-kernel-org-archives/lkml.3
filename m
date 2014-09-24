Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaIXPl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:41:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38994 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753498AbaIXPl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:41:56 -0400
Date: Wed, 24 Sep 2014 11:41:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Simek <michal.simek@xilinx.com>
cc: Chen Gang <gang.chen.5i5j@gmail.com>, <monstr@monstr.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/usb/host/ehci-xilinx-of.c: Include "linux/of_irq.h"
 to avoid compiling error
In-Reply-To: <e0dec78e-193e-43ee-bdb0-fa776a6dd044@BY2FFO11FD030.protection.gbl>
Message-ID: <Pine.LNX.4.44L0.1409241141260.1580-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Michal Simek wrote:

> Hi Alan and Greg,
> 
> On 09/20/2014 06:19 AM, Chen Gang wrote:
> > Hello Maintainers:
> > 
> > Please help check this patch, when you have time.
> > 
> > Thanks.
> > 
> > On 09/08/2014 01:20 PM, Michal Simek wrote:
> >> On 09/03/2014 05:50 PM, Chen Gang wrote:
> >>> Need include it for irq_of_parse_and_map(), the related error with
> >>> allmodconfig under microblaze:
> >>>
> >>>   drivers/usb/host/ehci-xilinx-of.c: In function ‘ehci_hcd_xilinx_of_probe’:
> >>>   drivers/usb/host/ehci-xilinx-of.c:156:2: error: implicit declaration of function ‘irq_of_parse_and_map’ [-Werror=implicit-function-declaration]
> >>>     irq = irq_of_parse_and_map(dn, 0);
> >>>     ^
> >>>
> >>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> >>> ---
> >>>  drivers/usb/host/ehci-xilinx-of.c | 1 +
> >>>  1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
> >>> index fe57710..a232836 100644
> >>> --- a/drivers/usb/host/ehci-xilinx-of.c
> >>> +++ b/drivers/usb/host/ehci-xilinx-of.c
> >>> @@ -31,6 +31,7 @@
> >>>  #include <linux/of.h>
> >>>  #include <linux/of_platform.h>
> >>>  #include <linux/of_address.h>
> >>> +#include <linux/of_irq.h>
> >>>  
> >>>  /**
> >>>   * ehci_xilinx_port_handed_over - hand the port out if failed to enable it
> >>>
> >>
> >> Acked-by: Michal Simek <monstr@monstr.eu>
> 
> Alan: Can you please add this patch to your queue?
> Greg: If Alan is not maintaining this part of kernel, is this patch in your queue?
> 
> I have also not a problem to add this patch through my microblaze tree
> but I think it will be much better to use any USB tree.

Greg should be able to accept a trivial patch like this one directly.

Alan Stern

