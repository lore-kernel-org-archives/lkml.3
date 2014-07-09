Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbaGIXDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:03:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaGIXDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:03:24 -0400
Date: Wed, 9 Jul 2014 16:07:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Chen, Alvin" <alvin.chen@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v5] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Message-ID: <20140709230749.GA22234@kroah.com>
References: <1404291498-28841-1-git-send-email-alvin.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404291498-28841-1-git-send-email-alvin.chen@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 01:58:18AM -0700, Chen, Alvin wrote:
> From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> 
> The EHCI packet buffer in/out threshold is programmable for Intel Quark X1000
> USB host controller, and the default value is 0x20 dwords. The in/out threshold
> can be programmed to 0x80 dwords (512 Bytes) to maximize the perfomrance,
> but only when isochronous/interrupt transactions are not initiated by the USB
> host controller. This patch is to reconfigure the packet buffer in/out
> threshold as maximal as possible to maximize the performance, and 0x7F dwords
> (508 Bytes) should be used because the USB host controller initiates
> isochronous/interrupt transactions.
> 
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Changlog v5:
> * Correct the wrong comment style.
> 
>  drivers/usb/host/ehci-pci.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)

This should go to stable kernel releases as well, right?

thanks,

greg k-h
