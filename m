Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab3LTS4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:56:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3LTS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:56:41 -0500
Date: Fri, 20 Dec 2013 10:56:50 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Aaro Koskinen <aaro.koskinen@nsn.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        linux-kernel@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] uio: fix devm_request_irq usage
Message-ID: <20131220185650.GA26584@kroah.com>
References: <1387549187-10068-1-git-send-email-aaro.koskinen@nsn.com>
 <20131220164913.GA29422@kroah.com>
 <20131220180113.GF2881@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220180113.GF2881@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 08:01:13PM +0200, Aaro Koskinen wrote:
> Hi,
> 
> On Fri, Dec 20, 2013 at 08:49:13AM -0800, Greg Kroah-Hartman wrote:
> > On Fri, Dec 20, 2013 at 04:19:47PM +0200, Aaro Koskinen wrote:
> > > Commit e6789cd3dfb553077606ccafeb05e0043f072481 (uio: Simplify uio error
> > > path by using devres functions) converted uio to use devm_request_irq().
> > > This introduced a change in behaviour since the IRQ is associated with
> > > the parent device instead of the created UIO device. The IRQ will remain
> > > active after uio_unregister_device() is called, and some drivers will
> > > crash because of this. The patch fixes this.
> > 
> > What drivers crash because of this?  Any in-kernel drivers?
> 
> I saw a crash with Intel DPDK (http://www.dpdk.org/) igb_uio
> driver. Basically, they do:
> 
> 	uio_unregister_device
> 	pci_disable_msix <-- this will BUG() if there is an active IRQ
> 
> I cannot test any of the in-tree UIO drivers, but at least some
> of them seem to release resources the IRQ handler might use after
> uio_unregister_device(). So if the IRQ fires results would not probably
> be very good.

Ok, thanks, I'll queue this up for 3.14-rc1 and tag it for 3.13-stable
so that people who have external modules can get the fix then.

greg k-h
