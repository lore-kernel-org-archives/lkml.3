Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbaCDWoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:44:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:53321 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbaCDWoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:44:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,588,1389772800"; 
   d="scan'208";a="494108685"
Date: Tue, 4 Mar 2014 14:44:01 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        stable@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH v3 1/1] xhci: Prevent runtime pm from autosuspending
 during initialization
Message-ID: <20140304224401.GB14620@xanatos>
References: <1393867817-10389-1-git-send-email-mathias.nyman@linux.intel.com>
 <1393867817-10389-2-git-send-email-mathias.nyman@linux.intel.com>
 <20140303183733.GA13926@kroah.com>
 <5315BE1F.8020100@linux.intel.com>
 <20140304170458.GA10789@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304170458.GA10789@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 09:04:58AM -0800, Greg KH wrote:
> On Tue, Mar 04, 2014 at 01:50:55PM +0200, Mathias Nyman wrote:
> > On 03/03/2014 08:37 PM, Greg KH wrote:
> > >On Mon, Mar 03, 2014 at 07:30:17PM +0200, Mathias Nyman wrote:
> > >>xHCI driver has its own pci probe function that will call usb_hcd_pci_probe
> > >>to register its usb-2 bus, and then continue to manually register the
> > >>usb-3 bus. usb_hcd_pci_probe does a pm_runtime_put_noidle at the end and
> > >>might thus trigger a runtime suspend before the usb-3 bus is ready.
> > >
> > >What is the result if that happens?
> > 
> > Crashes. Null pointer dereference in xhci_suspend() when touching
> > xhci->shared_hcd before it's initialized. More info here:
> > 
> > http://marc.info/?l=linux-usb&m=138914518219334&w=2
> > 
> > >
> > >Is this a regression from 3.13?  Or something new for 3.14?
> > >
> > 
> > According to reporter its been around since 3.7
> > 
> > commit 596d789a211d134dc5f94d1e5957248c204ef850
> > USB: set hub's default autosuspend delay as 0
> > 
> > But nobody else than the reporter is able to trigger it.
> 
> Then it can wait for 3.15-rc1, and then go back to the stable trees at
> that time, right?  I'd prefer that as it's not a regression and not
> common.

Ok, I'll queue it with the other features for 3.15.

Sarah Sharp
