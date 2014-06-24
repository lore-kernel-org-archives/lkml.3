Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaFXNY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:24:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbaFXNY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:24:56 -0400
Date: Tue, 24 Jun 2014 09:24:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Chen, Alvin" <alvin.chen@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Message-ID: <20140624132444.GA1215@kroah.com>
References: <1403625103-28078-1-git-send-email-alvin.chen@intel.com>
 <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 08:51:43AM -0700, Chen, Alvin wrote:
> From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> 
> This patch is to enable USB host controller for Intel Quark X1000. Add pci quirks
> to adjust the packet buffer in/out threshold value, and ensure EHCI packet buffer
> i/o threshold value is reconfigured to half.
> 
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> ---
>  drivers/usb/host/ehci-pci.c   |    4 ++++
>  drivers/usb/host/pci-quirks.c |   42 +++++++++++++++++++++++++++++++++++++++++
>  drivers/usb/host/pci-quirks.h |    2 ++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index 3e86bf4..33cfa23 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -50,6 +50,10 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
>  	if (!retval)
>  		ehci_dbg(ehci, "MWI active\n");
>  
> +	/* Reset the threshold limit */
> +	if(unlikely(usb_is_intel_qrk(pdev)))

Why unlikely()?  Have you measured a speed difference here?  And this is
a _very_ slow path, what does that speed difference you measured help
with?

thanks,

greg k-h
