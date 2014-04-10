Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934721AbaDJGxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 02:53:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36435 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933461AbaDJGxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 02:53:49 -0400
Date: Thu, 10 Apr 2014 08:53:46 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Willy Tarreau <w@1wt.eu>, Neil Greatorex <neil@fatboyfat.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        Matthew Minter <matthew_minter@xyratex.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] bus: mvebu-mbus: Avoid setting an undefined window
 size
Message-ID: <20140410085346.784631f9@skate>
In-Reply-To: <20140409162040.GA19743@obsidianresearch.com>
References: <1397000654-10849-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<20140409061128.GC16465@1wt.eu>
	<20140409162040.GA19743@obsidianresearch.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jason Gunthorpe,

On Wed, 9 Apr 2014 10:20:40 -0600, Jason Gunthorpe wrote:

> > OK I just got it by adding two printk() in pci-mvebu.c. Both functions
> > mvebu_pcie_handle_iobase_change() and mvebu_pcie_handle_membase_change()
> > do pass a size which is in fact a mask (size - 1) and not the real size.
> > So the mbus is fed with an incorrect size which is off by one :
> 
> Yes, that is right. I tested my patch here and didn't see any problem,
> but I realize now that the mbus code is bailing early due to this:
> 
> kernel: mvebu_mbus: cannot add window '4:e8', conflicts with another window
> 
> Which I've never got around to fixing.. (whole other story there)
> 
> Your patch looks fine, and it obviously needs to be sequenced before
> mine. (Thomas/Jason C: how do you want to do this?)

What I can propose is that I accumulate in a branch all the patches
needed to solve the various PCIe/Mbus problems we've identified:

 * Your patch adding warnings to the mvebu-mbus driver
 * Willy's patch fixing the off-by-one on the size
 * Neil's patch fixing the MSI teardown function
 * My two patches fixing the rest of the MSI logic
 * And patches to come for the link problem, and the cutting of
   non-power-of-two BARs into power-of-two windows

This way, everybody will be able to test than in his specific
hardware situations, the patches are solving all the problems. Then I
can take care of formally submitting those patches to the relevant
maintainers, of course keeping the authorship as appropriate.

How does that sound?

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
