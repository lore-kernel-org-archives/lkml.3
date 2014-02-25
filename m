Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaBYMYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:24:41 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50110 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753432AbaBYMYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:24:38 -0500
Date: Tue, 25 Feb 2014 12:24:24 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andy Gross <agross@codeaurora.org>
Cc: Joel Fernandes <joelf@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: Ideas/suggestions to avoid repeated locking and reducing too
	many lists with dmaengine?
Message-ID: <20140225122424.GW27282@n2100.arm.linux.org.uk>
References: <530B9784.5060904@ti.com> <20140224205028.GA24339@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224205028.GA24339@qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 02:50:28PM -0600, Andy Gross wrote:
> On Mon, Feb 24, 2014 at 01:03:32PM -0600, Joel Fernandes wrote:
> > Hi folks,
> > 
> > Just wanted your thoughts/suggestions on how we can avoid overhead in the EDMA
> > dmaengine driver. I am seeing a lots of performance drop specially for small
> > transfers with EDMA versus before raw EDMA was moved to DMAEngine framework
> > (atleast 25%).
> 
> I've seen roughly the same drop in my testing.  In my case it had to do
> with the nature of how work is done using virt-dma.  The virt-dma is
> predicated on only letting one transaction be active at a time and it
> increases the latency for getting the next transaction off.  For large
> transactions, it's negligible.  But for small transactions, it is pretty
> evident.

Wrong.  virt-dma allows you to fire off the next transaction in the queue
immediately that the previous transaction has finished.  I know this,
because sa11x0-dma does exactly that.

You don't need to wait for the tasklet to be called before starting the
next transaction.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
