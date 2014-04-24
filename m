Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaDXUPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:15:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:50821 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaDXUPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:15:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,921,1389772800"; 
   d="scan'208";a="526794219"
Date: Thu, 24 Apr 2014 13:15:11 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, linux-usb@vger.kernel.org,
        sarah.a.sharp@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb/xhci: fix compilation warning when !CONFIG_PCI
 && !CONFIG_PM
Message-ID: <20140424201511.GC16923@psi-dev26.jf.intel.com>
References: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
 <1398169382-12097-6-git-send-email-mathias.nyman@linux.intel.com>
 <20140424195032.GE12809@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140424195032.GE12809@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Apr 24, 2014 at 12:50:32PM -0700, Greg KH wrote:
> On Tue, Apr 22, 2014 at 03:23:02PM +0300, Mathias Nyman wrote:
> > From: David Cohen <david.a.cohen@linux.intel.com>
> > 
> > When CONFIG_PCI and CONFIG_PM are not selected, xhci.c gets this
> > warning:
> > drivers/usb/host/xhci.c:409:13: warning: ‘xhci_msix_sync_irqs’ defined
> > but not used [-Wunused-function]
> > 
> > Instead of creating nested #ifdefs, this patch fixes it by defining the
> > xHCI PCI stubs as inline.
> > 
> > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > ---
> >  drivers/usb/host/xhci.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> What patch caused this problem?  Does it show up in 3.14?  3.10?  2.0?
> :)
> 
> Please be more specific...

I first noticed this warning on 3.13, but I believe it is older :)
You may consider this patch as an extension of this other one:

commit d5c82feb5cf8026cd4af048330fdcd46e861c686
Author: Olof Johansson <olof@lixom.net>
Date:   Tue Jul 23 11:58:20 2013 -0700

    usb: xhci: Mark two functions __maybe_unused
--

IMO it makes sense to apply whenever the other patch exists.

Br, David
