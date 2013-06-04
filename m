Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3FDXGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:06:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:14278 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab3FDXFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:05:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,803,1363158000"; 
   d="scan'208";a="348192912"
Date: Tue, 4 Jun 2013 16:05:34 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, sarah.a.sharp@intel.com,
        linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [RFC PATCH v3 0/4] Add usb2 link powermanagement BESL support
Message-ID: <20130604230534.GB6289@xanatos>
References: <1369318471-10353-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369318471-10353-1-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, Greg, any more comments on this patchset?

It looks fine to me, and we've been testing it internally within Intel,
so I'll queue it up for 3.11 if you don't have any more objections.

Sarah Sharp

On Thu, May 23, 2013 at 05:14:27PM +0300, Mathias Nyman wrote:
> This series adds usb2 best effort service latency (BESL) link PM support
> to xHCI. BESL is an updated alternative to host initated resume delay
> (HIRD) method of describing idle link timeouts.
> 
> Additionally this series fixes port capability checking
> and replaces magic numbers with port register names.
> 
> Changes since v1:
> -Use kstrto* and unsigned values in sysfs functions as Alan Stern suggested    
> 
> Changes since v2:
> - Add Documentation/ABI/testing/sysfs-bus-usb entries for new sysfs attributes
> - store l1_timeout value in microseconds instead of xHCI specific values
> 
> Mathias Nyman (4):
>   usb: xhci: check usb2 port capabilities before adding hw link PM
>     support
>   usb: xhci: define port register names and use them instead of magic
>     numbers
>   usb: xhci: add USB2 Link power management BESL support
>   usb: add usb2 Link PM variables to sysfs and usb_device
> 
>  Documentation/ABI/testing/sysfs-bus-usb |   27 ++++
>  drivers/usb/core/sysfs.c                |   54 +++++++
>  drivers/usb/host/xhci-ext-caps.h        |    1 +
>  drivers/usb/host/xhci-hub.c             |   16 +--
>  drivers/usb/host/xhci-mem.c             |   33 ++++-
>  drivers/usb/host/xhci.c                 |  237 ++++++++++++++++++++++---------
>  drivers/usb/host/xhci.h                 |   29 ++++
>  include/linux/usb.h                     |   20 +++
>  8 files changed, 337 insertions(+), 80 deletions(-)
> 
> -- 
> 1.7.4.1
> 
