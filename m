Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaFGVLz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:11:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:60884 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbaFGVLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:11:54 -0400
Message-ID: <1402175478.3247.299.camel@pasglop>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>
Date: Sun, 08 Jun 2014 07:11:18 +1000
In-Reply-To: <Pine.LNX.4.44L0.1406071133090.31120-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1406071133090.31120-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-07 at 11:40 -0400, Alan Stern wrote:
> The current xhci-hcd driver includes a quirk flag (XHCI_SPURIOS_WAKEUP) 
> that causes the shutdown routine to reset the controller.  It wasn't 
> meant for fixing kexec problems, but I bet you could use it for that 
> purpose.
> 
> In addition, it's possible that a reset is needed in the probe pathway.

Ok, thanks. I'll have a look. A reset in the probe means fixing distros,
I'd rather find a way to fix it from the kexec path entirely, even if
that involves adding a quirk on the way out to reset it in shutdown()

I'll see what I can come up with that works and will come back to you.

Cheers,
Ben.


