Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaBXTEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:04:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37527 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaBXTEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:04:07 -0500
Message-ID: <530B9784.5060904@ti.com>
Date: Mon, 24 Feb 2014 13:03:32 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-rt-users@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Ideas/suggestions to avoid repeated locking and reducing too many
 lists with dmaengine?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Just wanted your thoughts/suggestions on how we can avoid overhead in the EDMA
dmaengine driver. I am seeing a lots of performance drop specially for small
transfers with EDMA versus before raw EDMA was moved to DMAEngine framework
(atleast 25%).

One of the things I am thinking about is the repeated (spin) locking/unlocking
of the virt_dma_chan->lock or vc->lock. In many cases, there's only 1 user or
thread requiring to do a DMA, so I feel the locking is unnecessary and potential
overhead. If there's a sane way to detect this an avoid locking altogether, that
would be great.

 Also with respect to virt_dma (which is used by edma to manage all the
descriptors and lists) there are too many lists: submitted, issued, completed
etc and the descriptor moves from one to the other. I am thinking if there is a
way we can avoid using so many lists and just have 2 lists and move the desc
from one list to the other, That could avoid using the intermediate list
altogether and classify dma requests as "done" or "not done".

Since this involves discussing concurrency primitives, copying linux-rt-users as
well.

Thanks,
-Joel
