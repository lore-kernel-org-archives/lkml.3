Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaETBBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 21:01:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaETBBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 21:01:40 -0400
Date: Tue, 20 May 2014 10:01:37 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com, Dan Williams <dan.j.williams@intel.com>,
        Holger Hans Peter Freyther <holger@moiji-mobile.com>
Subject: Re: [PATCH 02/10] xhci: 'noxhci_port_switch' kernel parameter
Message-ID: <20140520010137.GA8146@kroah.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
 <1399566363-25837-3-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399566363-25837-3-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 07:25:55PM +0300, Mathias Nyman wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Add a command line switch for disabling ehci port switchover.  Useful
> for working around / debugging xhci incompatibilities where ehci
> operation is available.
> 
> Reference: http://marc.info/?l=linux-usb&m=138920063001509&w=2
> 
> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Cc: Holger Hans Peter Freyther <holger@moiji-mobile.com>
> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  Documentation/kernel-parameters.txt |  3 +++
>  drivers/usb/host/pci-quirks.c       | 15 +++++++++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4384217..fc3403114 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2251,6 +2251,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
>  
> +	noxhci_port_switch
> +			[USB] Use EHCI instead of XHCI where available
> +

Ugh, I really don't like new command line options.

Especially one that isn't very well documented.  Why would someone want
to enable this?  What problem is it solving?  Can we detect this
automatically and do it for the user?  Is this just for prototype
hardware that has not shipped?  What hardware needs this?

I need a whole lot more documentation at the very least before I will
apply this.

thanks,

greg k-h
