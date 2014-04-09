Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbaDIHyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:54:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58003 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751161AbaDIHyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:54:05 -0400
Date: Wed, 9 Apr 2014 09:53:50 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Neil Greatorex <neil@fatboyfat.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        Matthew Minter <matthew_minter@xyratex.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] bus: mvebu-mbus: Avoid setting an undefined window
 size
Message-ID: <20140409095350.47029549@skate>
In-Reply-To: <20140409074752.GF16465@1wt.eu>
References: <1397000654-10849-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<20140409061128.GC16465@1wt.eu>
	<20140409091234.20f2e547@skate>
	<20140409074752.GF16465@1wt.eu>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Willy Tarreau,

On Wed, 9 Apr 2014 09:47:52 +0200, Willy Tarreau wrote:

> > Yes, the panic is expected: Jason's patch is not *fixing* anything,
> > it's just telling you *why* it's going to panic.
> 
> I just thought that the EINVAL would prevent one from registering
> the device, which would be more useful (if at all possible).

Unfortunately, I don't think that's possible: the function that sets up
the MBus window is called by the emulated bridge code, i.e when the
Linux PCI core thinks it is doing a write to a bridge register. And I
don't think there is a way of "refusing" the write to let the Linux
PCI core know that it was not possible to set up the bridge BAR as it
was requested.

Maybe this is something that Jason can confirm/infirm. I remember
having a quick look at the core Linux PCI core to see if it was
somehow checking whether the bridge BAR has been properly configured,
but I think I concluded it was not the case, and it was just assuming
that write the memory base/limit in the bridge registers was
sufficient. 

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
