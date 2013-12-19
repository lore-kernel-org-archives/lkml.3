Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3LSQA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:00:29 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42121 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab3LSQA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:00:27 -0500
Date: Thu, 19 Dec 2013 08:00:21 -0800
From: josh@joshtriplett.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 4/7] drivers: usb: Include appropriate header file in
 pci-quirks.c
Message-ID: <20131219160021.GA1658@cloud>
References: <e0ff2366ddbd62f75e8597008b1f3f9001224ad6.1387439261.git.rashika.kheria@gmail.com>
 <Pine.LNX.4.44L0.1312191047440.984-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1312191047440.984-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 10:51:50AM -0500, Alan Stern wrote:
> On Thu, 19 Dec 2013, Rashika Kheria wrote:
> 
> > Include header file include/linux/usb/hcd.h in host/pci-quirks.c because
> > function usb_hcd_amd_remote_wakeup_quirk() has its prototype declaration
> > in include/linux/usb/hcd.h.
> > 
> > This eliminates the following warning in host/pci-quirks.c:
> > drivers/usb/host/pci-quirks.c:253:5: warning: no previous prototype for ‘usb_hcd_amd_remote_wakeup_quirk’ [-Wmissing-prototypes]
> 
> Since when does the compiler complain about functions with no 
> prototype?

Sparse has warned about this for years, and GCC warns about it (for
functions only, not data) when given -Wmissing-prototypes, which it does
with "make W=1".  The intent is to call attention to functions that may
need to be marked static or removed, and to require inclusion of an
appropriate header for non-static functions, which then allows the
compiler to ensure that the prototype matches the definition.

> In any case, I think it would make more sense to move the prototype 
> declaration into drivers/usb/host/pci-quirks.h, and have 
> drivers/usb/core/hcd-pci.c include that file.  After all, it's 
> perfectly reasonable for hcd-pci to want to know about the quirks of 
> various PCI-based controllers, but it's not reasonable for pci-quirks.c 
> to need to know about the details of HCDs.

Sounds reasonable.

- Josh Triplett
