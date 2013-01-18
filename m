Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3ARDM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:12:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:51508 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab3ARDM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:12:57 -0500
Date: Thu, 17 Jan 2013 19:14:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH v6 1/2] PCI-Express Non-Transparent Bridge Support
Message-ID: <20130118031404.GA13239@kroah.com>
References: <1353119233-32752-1-git-send-email-jon.mason@intel.com>
 <1353119233-32752-2-git-send-email-jon.mason@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1353119233-32752-2-git-send-email-jon.mason@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:27:12PM -0700, Jon Mason wrote:
> A PCI-Express non-transparent bridge (NTB) is a point-to-point PCIe bus
> connecting 2 systems, providing electrical isolation between the two subsystems.
> A non-transparent bridge is functionally similar to a transparent bridge except
> that both sides of the bridge have their own independent address domains.  The
> host on one side of the bridge will not have the visibility of the complete
> memory or I/O space on the other side of the bridge.  To communicate across the
> non-transparent bridge, each NTB endpoint has one (or more) apertures exposed to
> the local system.  Writes to these apertures are mirrored to memory on the
> remote system.  Communications can also occur through the use of doorbell
> registers that initiate interrupts to the alternate domain, and scratch-pad
> registers accessible from both sides.
> 
> The NTB device driver is needed to configure these memory windows, doorbell, and
> scratch-pad registers as well as use them in such a way as they can be turned
> into a viable communication channel to the remote system.  ntb_hw.[ch]
> determines the usage model (NTB to NTB or NTB to Root Port) and abstracts away
> the underlying hardware to provide access and a common interface to the doorbell
> registers, scratch pads, and memory windows.  These hardware interfaces are
> exported so that other, non-mainlined kernel drivers can access these.
> ntb_transport.[ch] also uses the exported interfaces in ntb_hw.[ch] to setup a
> communication channel(s) and provide a reliable way of transferring data from
> one side to the other, which it then exports so that "client" drivers can access
> them.  These client drivers are used to provide a standard kernel interface
> (i.e., Ethernet device) to NTB, such that Linux can transfer data from one
> system to the other in a standard way.
> 
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>

Sorry for the very long delay, I've now applied these two patches,
thanks for the cleanups and changes from the original versions.

But, I now get the following build warning, so can you send a follow-on
patch that fixes it up before you start getting angry emails from the
0-day build bot?

drivers/ntb/ntb_transport.c: In function ‘ntb_transport_rx’:
drivers/ntb/ntb_transport.c:895:7: warning: ‘offset’ may be used uninitialized in this function [-Wuninitialized]
drivers/ntb/ntb_transport.c:891:8: note: ‘offset’ was declared here


thanks,

greg k-h
