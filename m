Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaESXcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:32:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:47606 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaESXcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:32:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,870,1392192000"; 
   d="scan'208";a="541748202"
Date: Mon, 19 May 2014 16:25:31 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/8] ixgbe: Out of line ixgbe_read/write_reg
Message-ID: <20140519232531.GJ19657@tassilo.jf.intel.com>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
 <1400276595-6965-2-git-send-email-andi@firstfloor.org>
 <7477F573-2AED-4D26-8D5F-DB80DFA7EDEF@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7477F573-2AED-4D26-8D5F-DB80DFA7EDEF@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:00:52PM +0000, Rustad, Mark D wrote:
> On May 16, 2014, at 2:43 PM, Andi Kleen <andi@firstfloor.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > ixgbe_read_reg and ixgbe_write_reg are frequently called and are very big
> > because they have complex error handling code.
> 
> Actually, this patch doesn't do anything to ixgbe_write_reg, which would almost certainly be very bad for performance, but instead changes ixgbe_write_reg64.

I doubt a few cycles around the write make a lot of difference for MMIO. MMIO is dominated
by other things.

> The latter is not in a performance-sensitive path, but is only called from one site, so there is little reason to take it out-of-line.

True I moved the wrong one.

ixgbe_write_reg                                    3305  (0.00%)  8     409  


> I already have a patch in queue to make ixgbe_read_reg out-of-line, because it does have a very costly memory footprint inline, as you have found.

Please move write_reg too.

-Andi
