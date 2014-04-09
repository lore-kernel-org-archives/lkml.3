Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148AbaDIQbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:31:19 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:57805 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143AbaDIQbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:31:17 -0400
Date: Wed, 9 Apr 2014 10:30:54 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Willy Tarreau <w@1wt.eu>, Neil Greatorex <neil@fatboyfat.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        Matthew Minter <matthew_minter@xyratex.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] bus: mvebu-mbus: Avoid setting an undefined window
 size
Message-ID: <20140409163054.GA30642@obsidianresearch.com>
References: <1397000654-10849-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20140409061128.GC16465@1wt.eu>
 <20140409091234.20f2e547@skate>
 <20140409074752.GF16465@1wt.eu>
 <20140409095350.47029549@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409095350.47029549@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 09:53:50AM +0200, Thomas Petazzoni wrote:

> Maybe this is something that Jason can confirm/infirm. I remember
> having a quick look at the core Linux PCI core to see if it was
> somehow checking whether the bridge BAR has been properly configured,
> but I think I concluded it was not the case, and it was just assuming
> that write the memory base/limit in the bridge registers was
> sufficient. 

I think the best way to fail would be to return an error from
mvebu_pcie_align_resource - but we can't create the window in that
call.

Once things get to the BAR write stage it shouldn't fail unfortunately.

Jason
