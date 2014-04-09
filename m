Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbaDIH46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:56:58 -0400
Received: from 1wt.eu ([62.212.114.60]:3706 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaDIH45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:56:57 -0400
Date: Wed, 9 Apr 2014 09:56:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Neil Greatorex <neil@fatboyfat.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        Matthew Minter <matthew_minter@xyratex.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] bus: mvebu-mbus: Avoid setting an undefined window size
Message-ID: <20140409075624.GA17071@1wt.eu>
References: <1397000654-10849-1-git-send-email-jgunthorpe@obsidianresearch.com> <20140409061128.GC16465@1wt.eu> <20140409091234.20f2e547@skate> <20140409074752.GF16465@1wt.eu> <20140409095350.47029549@skate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409095350.47029549@skate>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 09:53:50AM +0200, Thomas Petazzoni wrote:
> Dear Willy Tarreau,
> 
> On Wed, 9 Apr 2014 09:47:52 +0200, Willy Tarreau wrote:
> 
> > > Yes, the panic is expected: Jason's patch is not *fixing* anything,
> > > it's just telling you *why* it's going to panic.
> > 
> > I just thought that the EINVAL would prevent one from registering
> > the device, which would be more useful (if at all possible).
> 
> Unfortunately, I don't think that's possible: the function that sets up
> the MBus window is called by the emulated bridge code, i.e when the
> Linux PCI core thinks it is doing a write to a bridge register. And I
> don't think there is a way of "refusing" the write to let the Linux
> PCI core know that it was not possible to set up the bridge BAR as it
> was requested.
> 
> Maybe this is something that Jason can confirm/infirm. I remember
> having a quick look at the core Linux PCI core to see if it was
> somehow checking whether the bridge BAR has been properly configured,
> but I think I concluded it was not the case, and it was just assuming
> that write the memory base/limit in the bridge registers was
> sufficient. 

OK thanks for the detailed explanation!

Willy

